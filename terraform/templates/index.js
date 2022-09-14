/**
 * Poor man's webserver running as Cloudflare Workers.
 *
 * Based off the hostname and path being requested, respond with either file contents (stored in
 * a Workers KV namespace) or a redirect. Send request log entries to Datadog synchronously
 * (SLOWLY).
 */

addEventListener('fetch', event => {
	event.respondWith(_handleRequest(event.request));
});

const datadogUrl = 'https://http-intake.logs.datadoghq.com/api/v2/logs/';
const linkedinChatUrl = 'https://www.linkedin.com/messaging/thread/new?recipient=${linkedin_profile}&body=Your%20résumé%20is%20amazing,%20but';

// These paths are served for these requests and apply to all domains (evaluated before vhosting).
const pathMap = new Map ([
	['/${profile_photo_base}', '${profile_photo_base}'],
	['/favicon.ico',           'files/favicon.ico'],
	['/robots.txt',            'files/robots.txt'],
]);

// Domains (+optional paths) that should only redirect - not serving any content from here.
const redirectMap = new Map([
	['linkedin.${domain}', 'https://www.linkedin.com/in/${linkedin_profile}'],
	['chat.${domain}',     linkedinChatUrl],
	['meet.${domain}',     'https://calendly.com/${calendly_profile}'],
	['message.${domain}',  linkedinChatUrl],
	['source.${domain}',   'https://github.com/aflury/flurydotorg'],
]);


// Redirect every request to this domain to the url encoded in the path.
const redirectDomain = 'redirect.${domain}';

// Index (content) to show for each domain.
const indexMap = new Map([
	['${domain}',               'files/index.html'],
	['call.${domain}',          'templates/tel.html'],
	['cv.${domain}',            '${resume_file_base}'],
	['resume.${domain}',        '${resume_file_base}'],
	['text.${domain}',          'templates/sms.html'],
	['www.${domain}',           'files/index.html'],
	['xn--rsum-bpad.${domain}', '${resume_file_base}'],

]);

// Could use something like https://github.com/broofa/mime for a more fuller list.
const contentTypesMap = new Map ([
	['htm',  'text/html'],
	['html', 'text/html'],
	['gif',  'image/gif'],
	['ico',  'image/x-icon'],
	['jpg',  'image/jpeg'],
	['jpeg', 'image/jpeg'],
	['pdf',  'application/pdf'],
	['png',  'image/png'],
	['txt',  'text/plain'],
]);

const fourOhFour = 'files/404.html';


// Content-type is based off pathname extention alone. This isn't always correct, but
// as long as we're not publishing anything funny it should be ok.
function getHeaders(pathname) {
	var path_on_dots = pathname.split('.')
	var path_on_slash = pathname.split('/')
	var ext = path_on_dots[path_on_dots.length - 1];
	var base = path_on_slash[path_on_slash.length - 1];
	return {headers: {
		'Content-Type': contentTypesMap.get(ext, 'text/plain'),
		'Content-Disposition': 'filename="' + base + '"',
	}};
}

// XXX: This seems silly. It should probably be a 1-line library call, but I can't find
//      anything that wouldn't require pulling in 3rd party libraries, which is going
//      to be a rabbit hole.
function base64_decode(str) {
	try {
		str = atob(str);
		const ui = new Uint8Array(str.length);
		for (let i = 0; i < str.length; i++) {
	 	 	ui[i] = str.charCodeAt(i);
		}
		return ui;
	} catch (e) {
		console.log(e);
		return str;
	}
}

// Send log to datadog.
// TODO: Would be cool to use a durable object to queue up log entries then push them
//       to datadog in batches asynchonously, but durable objects require a paid worker
//       subscription that's another $5/mo and what does it look like I'm made of money
//       or something because if so I don't know for sure if that would work anyway.
function log(request, str) {
	const response = fetch(datadogUrl, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
			'DD-API-KEY': '${dd_api_key}',
			'DD-APPLICATION-KEY': '${dd_app_key}',
		},
		body: JSON.stringify([{
			'ddsource': 'nginx',  // We're sort of faking nginx logs, so, sure..
			'hostname': request.headers.get('CF-Connecting-IP'),
			'ddtags': '',
			'service': 'flurydotorg',
			'message': str,
		}]),
	});
}

// Build a log message that sorta looks like an httpd/nginx access log.
function logRequest(request, response) {
	log(request,
		request.headers.get('CF-Connecting-IP', '-') +
		' - - "' + request.method + ' ' + request.url + '" ' + response.status +
		' 0 - ' + '"' + request.headers.get("user-agent") + '"');
}

// Main request handler.
async function handleRequest(request) {
	const host = request.headers.get('Host').split(':')[0];
	const url = new URL(request.url);
	var response = null;
	const hostAndPath = host + url.pathname;

	// Handle specific pathnames.
	// Don't allow empty pathname to sneak in, or it'll clobber other requests.
	if (url.pathname != '/' && pathMap.has(url.pathname)) {
		const path = pathMap.get(url.pathname);
		const contents = await flurydotorg_namespace.get(path);
		response = new Response(base64_decode(contents), getHeaders(path));
	}
	// Redirect for any redirect-only subdomain.
	else if (host == redirectDomain || redirectMap.has(host) || redirectMap.has(hostAndPath)) {
		if (host == redirectDomain) {
			var quotedUrl = url.pathname.substring(1);
			try {
				var redirectUrl = new URL(decodeURIComponent(quotedUrl));
			} catch (e) {
				return new Response("URL '" + quotedUrl + "' failed to parse", {status: 500});
			}
		} else {
			var redirectUrl = new URL(redirectMap.get(host) || redirectMap.get(hostAndPath));
		}
		response = new Response(
			'<html><body>' +
			'Redirecting to <a href="' + redirectUrl.href + '">' + redirectUrl.href + '</a>' +
			'</body></html>',
			{
				status: 301,
				headers: {
					'location': redirectUrl.href,
					'Content-Type': 'text/html',
				}
			}
		);
	}
    // Serve up the default index for the subdomain.
	else if (url.pathname == '/' && indexMap.has(host)) {
		const path = indexMap.get(host);
		const contents = await flurydotorg_namespace.get(path);
		response = new Response(base64_decode(contents), getHeaders(path));
	}
	// Otherwise 404.
	else {
		response = new Response(base64_decode(await flurydotorg_namespace.get(fourOhFour)), {status: 404});
	}

	logRequest(request, response);
	return response;
}

async function _handleRequest(request) {
	try {
		return handleRequest(request);
	} catch (e) {
		return new Response("Internal error! Whoever runs this thing sucks!", {status: 500})
	}
}

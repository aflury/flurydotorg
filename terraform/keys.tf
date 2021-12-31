resource "aws_key_pair" "flurydotorg-ssh" {
  key_name   = "flurydotorg-ssh"
  public_key = file("../ssh-key.pub")
}


data "aws_caller_identity" "current" {}


output "aws_console_login_url" {
  value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
  description = "AWS Management Console login URL for the account."
}


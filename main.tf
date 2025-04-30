
data "aws_caller_identity" "current" {}


output "aws_console_login_url" {
  value       = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
  description = "AWS Management Console login URL for the account."
}

output "aws_iam_smtp_password_v4" {
  sensitive = true
  value = aws_iam_access_key.my_access_key.ses_smtp_password_v4
}
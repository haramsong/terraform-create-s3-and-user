resource "aws_ssm_parameter" "my_parameter_store" {
  name  = var.ssm_parameter_name
  type  = "String"
  value = "string"
}
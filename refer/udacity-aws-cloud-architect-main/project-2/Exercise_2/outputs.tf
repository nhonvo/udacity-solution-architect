# TODO: Define the output variable for the lambda function.
output "lambda_function_arn" {
  value = try(aws_lambda_function.greet_lambda_function.arn, "")
}

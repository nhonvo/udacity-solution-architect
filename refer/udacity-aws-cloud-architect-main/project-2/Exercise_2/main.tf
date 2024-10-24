locals {
  lambda_source_file = "greet_lambda.py"
  lambda_function_name = "greet_lambda"
  lambda_output_path = "lambda_output.zip"
}

provider "aws" {
  profile = "default"
  region = var.aws_region
}

data "archive_file" "greet_lambda_zip" {
  source_file = local.lambda_source_file
  output_path = local.lambda_output_path
  type = "zip"
}

data "aws_iam_policy_document" "greet_lambda_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "greet_lambda_log_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
    effect = "Allow"
  }
}

resource "aws_iam_role" "greet_lambda_role" {
  name = "${local.lambda_function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.greet_lambda_assume_role_policy_document.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

resource "aws_iam_policy" "greet_lambda_log_policy" {
  name = "function-logging-policy"
  policy = data.aws_iam_policy_document.greet_lambda_log_policy_document.json
}

resource "aws_iam_role_policy_attachment" "greet_lambda_logging_policy_attachment" {
  role = aws_iam_role.greet_lambda_role.id
  policy_arn = aws_iam_policy.greet_lambda_log_policy.arn
}

resource "aws_cloudwatch_log_group" "greet_lambda_log" {
  name = "/aws/lambda/greet_lambda"
  retention_in_days = 1
}

resource "aws_lambda_function" "greet_lambda_function" {
  function_name = "${local.lambda_function_name}"
  source_code_hash = data.archive_file.greet_lambda_zip.output_base64sha256
  filename = data.archive_file.greet_lambda_zip.output_path
  role = aws_iam_role.greet_lambda_role.arn
  handler = "greet_lambda.lambda_handler"
  runtime = "python3.12"

  environment {
    variables = {
      greeting = "Example greeting"
    }
  }

  depends_on = [aws_cloudwatch_log_group.greet_lambda_log, aws_iam_role_policy_attachment.greet_lambda_logging_policy_attachment]
}

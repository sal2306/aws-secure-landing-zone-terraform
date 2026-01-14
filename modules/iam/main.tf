variable "project_name" { type = string }

resource "aws_iam_role" "read_only" {
  name = "${var.project_name}-read-only"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "*" # In reality, restrict to specific accounts or SSO
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "read_only_attach" {
  role       = aws_iam_role.read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

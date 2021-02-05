# IAM profile for ec2 to use
resource "aws_iam_instance_profile" "test_profile" {
  name = "${local.application}_profile"
  role = aws_iam_role.iam-role.name
}

# Iam role to attach to profile
resource "aws_iam_role" "iam-role" {
  name = "iam-role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

# Attach a built-in policy to the role
resource "aws_iam_role_policy_attachment" "role_attach_ssm" {
  role = aws_iam_role.iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "iam-ssm-role-policy" {
  name = "ssm-policy"
  role = aws_iam_role.iam-role.id
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetEncryptionConfiguration"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}

# Create a new policy and attach it to the role
resource "aws_iam_role_policy" "builds-bucket-access-policy" {
  name = "builds-bucket-access-policy"
  role = aws_iam_role.iam-role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": ["arn:aws:s3:::*"]
      }
    ]
  }
  EOF
}


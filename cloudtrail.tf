data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "cloudtrail-log-group"
  retention_in_days = 30
}

resource "aws_iam_role" "cloudtrail_cloudwatch_role" {
  name = "cloudtrail-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        Sid       = "EnableIAMUserPermissions",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action    = "kms:*",
        Resource  = "*"
      }
    ]
  })
}




resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "cloudtrail-log-bucket-team5"
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
}


resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action    = "s3:GetBucketAcl",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.id}"
      },
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action    = "s3:PutObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_policy" {
  name        = "cloudtrail-cloudwatch-policy"
  description = "Allows CloudTrail to write to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = [
          "${aws_cloudwatch_log_group.cloudtrail_logs.arn}",
          "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_attach" {
  role       = aws_iam_role.cloudtrail_cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_policy.arn
}

resource "aws_cloudtrail" "main_cloudtrail" {
  name                          = "my-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  cloud_watch_logs_group_arn = "arn:aws:logs:ap-northeast-2:557690622101:log-group:cloudtrail-log-group:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_role.arn
}

# SNS Topic 생성 (CloudWatch 알람을 구독할 주제)
resource "aws_sns_topic" "cpu_alarm_sns" {
  name = "SNS-cpu_alarm"
}

# CloudWatch Metric Alarm 생성
resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name                = "High-CPU-Usage-Alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 70
  alarm_description         = "This alarm triggers when CPU usage is above 70% for 1 minute."
  dimensions = {
    InstanceId = "i-0e7da11eef5041572"  # 여기에 배스천 호스트 인스턴스 ID를 입력하세요.
  }

  # 알람 발생 시 SNS 주제로 알림을 전송
  alarm_actions = [
    aws_sns_topic.cpu_alarm_sns.arn
  ]
  ok_actions = [
    aws_sns_topic.cpu_alarm_sns.arn
  ]
  insufficient_data_actions = [
    aws_sns_topic.cpu_alarm_sns.arn
  ]
}

# SNS Topic을 CloudWatch Logs에 연결하는 구독 생성
resource "aws_sns_topic_subscription" "cpu_alarm_subscription" {
  topic_arn = aws_sns_topic.cpu_alarm_sns.arn
  protocol  = "email"
  endpoint  = "gyudol99@naver.com"  # 알림을 받을 이메일 주소를 입력하세요
}

# CloudWatch Event Rule - EC2 인스턴스 상태 변경 시 로그 기록
resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name        = "EC2StateChangeRule"
  description = "Rule for EC2 state change events"
  event_pattern = jsonencode({
    source = ["aws.ec2"],
    detail-type = ["EC2 Instance State-change Notification"],
    detail = {
      state = ["stopped", "terminated"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ec2_state_change_target" {
  rule      = aws_cloudwatch_event_rule.ec2_state_change.name
  target_id = "cloudtrail-logs-target"
  arn       = aws_cloudwatch_log_group.cloudtrail_logs.arn
}

# 인스턴스 상태 변경 이벤트에 대해 CloudWatch Logs에 로그를 기록할 수 있도록 권한 추가
resource "aws_iam_role_policy" "ec2_state_change_policy" {
  name   = "ec2-state-change-policy"
  role   = aws_iam_role.cloudtrail_cloudwatch_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = "logs:PutLogEvents"
        Resource = aws_cloudwatch_log_group.cloudtrail_logs.arn
      }
    ]
  })

  depends_on = [aws_cloudwatch_log_group.cloudtrail_logs]
}


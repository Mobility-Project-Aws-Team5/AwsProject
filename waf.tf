# # WAF 로그 전송 설정
# resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
#   resource_arn = "arn:aws:wafv2:ap-northeast-2:557690622101:regional/webacl/Test-waf-acl/c647f522-c196-4f90-ad92-be2999f5b7da" # Web ACL ARN 변경

#   log_destination_configs = [
#     aws_cloudwatch_log_group.waf_log_group.arn
#   ]
# }

# # CloudWatch Log 그룹 설정
# resource "aws_cloudwatch_log_group" "waf_log_group" {
#   name              = "cloutrail-log-group"
#   retention_in_days = 30
# }

# # IAM 역할 생성 (WAF 로그 전송을 위한 권한 부여)
# resource "aws_iam_role" "waf_logging_role" {
#   name               = "waf-logging-role"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "waf.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# # IAM 정책 생성
# resource "aws_iam_policy" "waf_logging_policy" {
#   name        = "waf-logging-policy"
#   description = "Policy for WAF to send logs to CloudWatch"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents",
#         "logs:DescribeLogGroups",
#         "logs:DescribeLogStreams"
#       ],
#       "Resource": "${aws_cloudwatch_log_group.waf_log_group.arn}:*"
#     }
#   ]
# }
# EOF
# }

# # 역할과 정책 연결
# resource "aws_iam_role_policy_attachment" "waf_logging_role_attach" {
#   role       = aws_iam_role.waf_logging_role.name
#   policy_arn = aws_iam_policy.waf_logging_policy.arn
# }

# # CloudTrail 설정 (로그 기록 활성화)
# resource "aws_cloudtrail" "cloudtrail" {
#   name                          = "cloudtrail"
#   s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.bucket
#   is_multi_region_trail         = true
#   include_global_service_events = true
#   enable_logging                = true

#   event_selector {
#     read_write_type           = "All"
#     include_management_events = true
#   }
# }


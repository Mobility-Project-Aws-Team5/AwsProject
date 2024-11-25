# WAF와 API Gateway 연동
resource "aws_wafv2_web_acl_association" "Test_Waf_association" {
  resource_arn = aws_api_gateway_stage.Test_gateway_stage.arn
  web_acl_arn  = aws_wafv2_web_acl.Test_Waf.arn
}


# CloudWatch Dashboard for Multiple Instances and Load Balancer RequestCount
resource "aws_cloudwatch_dashboard" "example" {
  dashboard_name = "MyDashboard"
  dashboard_body = jsonencode({
    widgets = [
      # Title for Instances Section
      {
        type = "text",
        properties = {
          markdown = "# Instances CPU Utilization"
        }
        x      = 0,
        y      = 0,
        width  = 18,
        height = 1
      },
      # CPU Usage Widget for Bastion-host
      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "i-0e7da11eef5041572" ]  # Bastion-host Instance ID
          ],
          region  = "ap-northeast-2",
          stat    = "Average",
          title   = "Bastion-host CPU Utilization"
        }
        x      = 0,
        y      = 1,
        width  = 6,
        height = 6
      },
      # CPU Usage Widget for Private-Subnet_1
      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "i-009016a047dabf288" ]  # Private-Subnet_1 Instance ID
          ],
          region  = "ap-northeast-2",
          stat    = "Average",
          title   = "Private-Subnet_1 CPU Usage"
        }
        x      = 6,
        y      = 1,
        width  = 6,
        height = 6
      },
      # CPU Usage Widget for Private-Subnet_2
      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "i-0ff024f2c08f4c31b" ]  # Private-Subnet_2 Instance ID
          ],
          region  = "ap-northeast-2",
          stat    = "Average",
          title   = "Private-Subnet_2 CPU Usage"
        }  
        x      = 12,
        y      = 1,
        width  = 6,
        height = 6        
      },
      # Title for Load Balancer Section
      {
        type = "text",
        properties = {
          markdown = "# Load Balancer Request Count"
        }
        x      = 0,
        y      = 7,
        width  = 18,
        height = 1
      },
      # Request Count Widget for Load Balancer
      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "app/dev-eks-alb/82c5aae9bbe578db" ]  # ALB 이름과 ARN
          ],
          region  = "ap-northeast-2",
          stat    = "Sum",
          title   = "Dev_lb Request Count"
        }
        x      = 0,
        y      = 8,
        width  = 6,
        height = 6
      },

      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "app/test-eks-alb/79bcc0942632d75d" ]  # ALB 이름과 ARN
          ],
          region  = "ap-northeast-2",
          stat    = "Sum",
          title   = "Test_lb Request Count"
        }
        x      = 6,
        y      = 8,
        width  = 6,
        height = 6
      },

      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "app/prod-eks-alb/f5e5d82a57406fc6" ]  # ALB 이름과 ARN
          ],
          region  = "ap-northeast-2",
          stat    = "Sum",
          title   = "Prod_lb Request Count"
        }
        x      = 12,
        y      = 8,
        width  = 6,
        height = 6
      },

      {
        type = "text",
        properties = {
          markdown = "# VPN Tunnel Monitoring"
        },
        x      = 0,
        y      = 15,
        width  = 18,
        height = 1
      },
      # Tunnel Activation State Widget (Single Graph, Two Tunnels)
      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/VPN", "TunnelState", "VpnId", "vpn-0cf0fc3c5d5b6cb0b", "TunnelIpAddress", "15.165.166.152" ],  # Tunnel 1
            [ ".", ".", "VpnId", "vpn-0cf0fc3c5d5b6cb0b", "TunnelIpAddress", "54.180.195.68" ]                 # Tunnel 2
          ],
          view       = "timeSeries",
          region     = "ap-northeast-2",
          stat       = "Average",
          title      = "Tunnel Activation State",
          yAxis      = {
            left = { min = 0, max = 1 }  # Tunnel 상태는 0 또는 1만 가능
          }
        },
        x      = 0,
        y      = 16,
        width  = 9,
        height = 6
      },
      # Tunnel Data Transfer Widget (Single Graph, Two Tunnels)
      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/VPN", "TunnelDataIn", "VpnId", "vpn-0cf0fc3c5d5b6cb0b", "TunnelIpAddress", "15.165.166.152" ],  # Tunnel 1 In
            [ ".", "TunnelDataOut", "VpnId", "vpn-0cf0fc3c5d5b6cb0b", "TunnelIpAddress", "15.165.166.152" ],       # Tunnel 1 Out
            [ ".", "TunnelDataIn", "VpnId", "vpn-0cf0fc3c5d5b6cb0b", "TunnelIpAddress", "54.180.195.68" ],       # Tunnel 2 In
            [ ".", "TunnelDataOut", "VpnId", "vpn-0cf0fc3c5d5b6cb0b", "TunnelIpAddress", "54.180.195.68" ]       # Tunnel 2 Out
          ],
          view       = "timeSeries",
          region     = "ap-northeast-2",
          stat       = "Sum",
          title      = "Tunnel Data Transfer (In/Out)",
          yAxis      = {
            left = { min = 0 }
          }
        },
        x      = 9,
        y      = 16,
        width  = 9,
        height = 6
      },

      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/WAFV2", "BlockedRequests", "WebACL", aws_wafv2_web_acl.Test_Waf.name, "RuleName", "SQLInjectionRule" ]
          ],
          region  = "ap-northeast-2",
          stat    = "Sum",
          title   = "SQL Injection Blocked Requests"
        },
        x      = 0,
        y      = 21,
        width  = 6,
        height = 6
      },

      # XSS 차단 규칙 모니터링
      {
        type = "metric",
        properties = {
          metrics = [
            [ "AWS/WAFV2", "BlockedRequests", "WebACL", aws_wafv2_web_acl.Test_Waf.name, "RuleName", "XSSRule" ]
          ],
          region  = "ap-northeast-2",
          stat    = "Sum",
          title   = "XSS Blocked Requests"
        },
        x      = 6,
        y      = 21,
        width  = 6,
        height = 6
      }
    ]
  })
}

# SNS Topic for Alarm Notifications
resource "aws_sns_topic" "example" {
  name = "cpu-usage-alerts"
}

# SNS Subscription for Email Notifications
resource "aws_sns_topic_subscription" "example" {
  topic_arn = aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = "gyudol99@naver.com"  # Replace with your email address
}

# CloudWatch Alarm for High CPU Usage on Bastion-host (Instance 1)
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_bastion" {
  alarm_name          = "HighCPUUsageBastion"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 80  
  alarm_description   = "This alarm triggers if CPU usage on Bastion-host exceeds 80%."
  actions_enabled     = true

  alarm_actions = [
    aws_sns_topic.example.arn
  ]

  dimensions = {
    InstanceId = "i-0779207c74bfa9ea5"  # Bastion-host Instance ID
  }
}

# CloudWatch Alarm for High CPU Usage on Private-Subnet_1 (Instance 2)
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_private_subnet_1" {
  alarm_name          = "HighCPUUsagePrivateSubnet1"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 80  
  alarm_description   = "This alarm triggers if CPU usage on Private-Subnet_1 exceeds 80%."
  actions_enabled     = true

  alarm_actions = [
    aws_sns_topic.example.arn
  ]

  dimensions = {
    InstanceId = "i-009016a047dabf288"  # Private-Subnet_1 Instance ID
  }
}

# CloudWatch Alarm for High CPU Usage on Private-Subnet_2 (Instance 3)
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_private_subnet_2" {
  alarm_name          = "HighCPUUsagePrivateSubnet2"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 80  
  alarm_description   = "This alarm triggers if CPU usage on Private-Subnet_2 exceeds 80%."
  actions_enabled     = true

  alarm_actions = [
    aws_sns_topic.example.arn
  ]

  dimensions = {
    InstanceId = "i-0ff024f2c08f4c31b"  # Private-Subnet_2 Instance ID
  }
}
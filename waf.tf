# API Gateway 설정
resource "aws_api_gateway_rest_api" "Test_gateway" {
  name        = "Test-gateway"
  description = "API Gateway"
}

resource "aws_api_gateway_resource" "Test_gateway" {
  rest_api_id = aws_api_gateway_rest_api.Test_gateway.id
  parent_id   = aws_api_gateway_rest_api.Test_gateway.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "Test_gateway" {
  rest_api_id   = aws_api_gateway_rest_api.Test_gateway.id
  resource_id   = aws_api_gateway_resource.Test_gateway.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "Test_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.Test_gateway.id
  resource_id             = aws_api_gateway_resource.Test_gateway.id
  http_method             = aws_api_gateway_method.Test_gateway.http_method
  integration_http_method = "GET"
  type                    = "MOCK"
}

resource "aws_api_gateway_deployment" "Test_gateway" {
  rest_api_id = aws_api_gateway_rest_api.Test_gateway.id
  stage_name  = "dev"

  depends_on = [
    aws_api_gateway_method.Test_gateway,
    aws_api_gateway_integration.Test_gateway_integration
  ]
}

resource "aws_api_gateway_stage" "Test_gateway_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.Test_gateway.id
  deployment_id = aws_api_gateway_deployment.Test_gateway.id
#   depends_on = [aws_api_gateway_deployment.Test_gateway]
}

# WAF 설정
resource "aws_wafv2_web_acl" "Test_Waf" {
  name        = "Test-waf-acl"
  description = "WAF Web ACL for API Gateway"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # SQL Injection 방지 규칙
  rule {
    name     = "SQLInjectionRule"
    priority = 1

    action {
      block {}
    }

    statement {
      sqli_match_statement {
        field_to_match {
          body {}
        }
        text_transformation {
          priority = 0
          type     = "URL_DECODE"
        }
        text_transformation {
          priority = 1
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjectionRule"
      sampled_requests_enabled   = true
    }
  }

  # XSS 방지 규칙
  rule {
    name     = "XSSRule"
    priority = 2

    action {
      block {}
    }

    statement {
      xss_match_statement {
        field_to_match {
          body {} # 요청 본문에서 XSS 탐지
        }
        text_transformation {
          priority = 0
          type     = "URL_DECODE"
        }
        text_transformation {
          priority = 1
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "XSSRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "Test_Waf"
    sampled_requests_enabled   = true
  }
}

# WAF와 API Gateway 연동
resource "aws_wafv2_web_acl_association" "Test_Waf_association" {
  resource_arn = aws_api_gateway_stage.Test_gateway_stage.arn
  web_acl_arn  = aws_wafv2_web_acl.Test_Waf.arn
}

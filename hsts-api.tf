resource "aws_api_gateway_rest_api" "HSTS" {
  name = "HSTS"
  description = "HSTS response app" 
}

resource "aws_api_gateway_method" "HSTS" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  resource_id = "${aws_api_gateway_rest_api.HSTS.root_resource_id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "HSTS" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  resource_id = "${aws_api_gateway_rest_api.HSTS.root_resource_id}"
  http_method = "${aws_api_gateway_method.HSTS.http_method}"
  type = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "301" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  resource_id = "${aws_api_gateway_rest_api.HSTS.root_resource_id}"
  http_method = "${aws_api_gateway_method.HSTS.http_method}"
  status_code = "301"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Location" = true
    "method.response.header.Strict-Transport-Security" = true
  }
}

resource "aws_api_gateway_integration_response" "HSTS" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  resource_id = "${aws_api_gateway_rest_api.HSTS.root_resource_id}"
  http_method = "${aws_api_gateway_method.HSTS.http_method}"
  status_code = "${aws_api_gateway_method_response.301.status_code}"
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Location" = "'https://eat-at-joes.example.com'"
    "method.response.header.Strict-Transport-Security" = "'max-age=10886400; includeSubDomains; preload'"
  }
}

resource "aws_api_gateway_domain_name" "HSTS" {
  domain_name = "hsts2.unixbeard.net"

  certificate_name        = "system_dev"
  certificate_body        = "${file("cert.pem")}"
  certificate_private_key = "${file("key.pem")}"
  certificate_chain       = "${file("chain.pem")}"
}

resource "aws_api_gateway_base_path_mapping" "HSTS" {
  api_id      = "${aws_api_gateway_rest_api.HSTS.id}"
  base_path = "(none)"
  domain_name = "${aws_api_gateway_domain_name.HSTS.domain_name}"
}


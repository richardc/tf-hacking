resource "aws_api_gateway_rest_api" "HSTS" {
  name = "HSTS"
  description = "HSTS response app" 
}

resource "aws_api_gateway_resource" "HSTS" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  parent_id = "${aws_api_gateway_rest_api.HSTS.root_resource_id}"
  path_part = "/"
}

resource "aws_api_gateway_method" "HSTS" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  resource_id = "${aws_api_gateway_resource.HSTS.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "HSTS" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  resource_id = "${aws_api_gateway_resource.HSTS.id}"
  http_method = "${aws_api_gateway_method.HSTS.http_method}"
  type = "MOCK"
}

resource "aws_api_gateway_method_response" "301" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  resource_id = "${aws_api_gateway_resource.HSTS.id}"
  http_method = "${aws_api_gateway_method.HSTS.http_method}"
  status_code = "301"
}

resource "aws_api_gateway_integration_response" "HSTS" {
  rest_api_id = "${aws_api_gateway_rest_api.HSTS.id}"
  resource_id = "${aws_api_gateway_resource.HSTS.id}"
  http_method = "${aws_api_gateway_method.HSTS.http_method}"
  status_code = "${aws_api_gateway_method_response.301.status_code}"
}

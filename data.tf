data "aws_acm_certificate" "acm_domain" {
  domain   = "cloudriann.com"
  statuses = ["ISSUED"]
}

output "acm_output" {
  value = "cloudriann.com"
}
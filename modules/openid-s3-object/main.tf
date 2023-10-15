locals {
  jwks_s3_key      = ".well-known/jwks.json"
  open_id_conf_key = ".well-known/openid-configuration"
  issuer_uri       = "https://${var.bucket_domain_name}/"
  jwks_uri         = "${local.issuer_uri}${local.jwks_s3_key}"
}

resource "aws_s3_object" "jwks" {
  bucket = var.bucket_domain_name
  key    = local.jwks_s3_key
  source = var.path_to_jwks
  etag   = filemd5(var.path_to_jwks)
}

resource "aws_s3_object" "openid-conf" {
  bucket  = var.bucket_domain_name
  key     = local.open_id_conf_key
  content = <<EOT
{
    "issuer":"${local.issuer_uri}",
    "jwks_uri":"${local.jwks_uri}"
}  
EOT

}
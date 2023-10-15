locals {
    create_bucket = var.public-s3-bucket == ""
}

module "openid_bucket" {
    count = local.create_bucket ? 1 : 0
    
    source = "./modules/openid-s3-bucket"
}


module "openid_s3_objects" {
    source = "./modules/openid-s3-object"
    bucket_domain_name = local.create_bucket ? module.openid_bucket[0].bucket.id : var.public-s3-bucket
    path_to_jwks = var.path_to_jwks
}
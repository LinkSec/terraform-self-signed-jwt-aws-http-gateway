variable "path_to_jwks" {
    description = "Path to jwks.json file containing public key."    
}

variable "public-s3-bucket" {
    description = "(Optional) Name of existing bucket to host public OpenID openid-configuration and jwks.json files. If not specified, a new public bucket will be created."
    default = ""
    type = string
}


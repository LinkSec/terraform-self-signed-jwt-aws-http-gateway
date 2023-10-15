# Why might you want to use self-signed JSON Web Tokens?
There are plenty of well-established and trusted providers for authentication in modern systems, all of which support JWT, so why would you want to roll your own and use self-signed JSON Web Tokens?

Existing legacy applications or their compliance requirements may not be compatible with these authentication providers, and at larger scales the cost of authentication services could become prohibitive. Or alternatively, you require a very specific login or password reset flows that aren't handled correctly by these providers. In our case, to recreate a necessary authentication flow with AWS Cognito User pool's custom Authentication flow was needlessly complex to model.



# Usage
## Key generation (e.g. RSA)
```sh
openssl genrsa -out private.key 4096
openssl rsa -in private.key -pubout -out public.key
```
Extract the public key between the lines `-----BEGIN PUBLIC KEY-----` and `-----END PUBLIC KEY-----` and create a `jwks.json` file:
```json
{
  "keys": [
    {
      "alg": "RS256", 
      "kty": "RSA",
      "use": "sig",
      "kid": "key-id",
      "x5c": [ "<INSERT PUBLIC KEY HERE>"]
    }
  ]
}
```
Use the filepath of `jwks.json` as input for the `terraform-self-signed-jwt-aws-http-gateway` terraform module. Keep the private key secret and use it in your back end when signing tokens to be given to users.
## Deployment
```hcl
module "self-signed-jwt-auth" {
    source = "github.com/dropdump/terraform-self-signed-jwt-aws-http-gateway"
    path_to_jwks = "/path/to/jwks.json"
}

// use `module.self-signed-jwt-auth.issuer_uri` as issuer in the HTTP authorizer 
resource "aws_apigatewayv2_authorizer" "jwt-authorizer" {
  name             = "jwt-authorizer"
  api_id           = aws_apigatewayv2_api.example.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  jwt_configuration {
    audience = ["your-key-id"]
    issuer   = module.self-signed-jwt-auth.issuer_uri
  }
}

```

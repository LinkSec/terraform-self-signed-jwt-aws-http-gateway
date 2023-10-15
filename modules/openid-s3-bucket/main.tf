resource "random_id" "id" {
	  byte_length = 8
}

resource "aws_s3_bucket" "public" {
  bucket = "public-openid-${random_id.id.hex}"
}


resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.public.id

  block_public_acls   = false
  block_public_policy = false
}


resource "aws_s3_bucket_policy" "allow_public_object_read" {
  depends_on = [  aws_s3_bucket_public_access_block.public_access_block]
  
  bucket = aws_s3_bucket.public.id
  policy = data.aws_iam_policy_document.allow_public_object_read.json
}

data "aws_iam_policy_document" "allow_public_object_read" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.public.arn}/*",
    ]
  }
}
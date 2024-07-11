#creating s3 bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# s3 bucket ownership 

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# s3 bucket public access block ;
# make arguments false

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id


  block_public_acls       = false            
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# s3 bucket public ACL

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# s3 objects

resource "aws_s3_object" "index" {
  key    = "index.html"
  bucket = aws_s3_bucket.mybucket.id
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  key    = "error.html"
  bucket = aws_s3_bucket.mybucket.id
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}

# s3 website configuration

resource "aws_s3_bucket_website_configuration" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket.mybucket ]
}
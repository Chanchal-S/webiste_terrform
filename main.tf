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

provider "aws" {
  region = "ap-northeast-1"
  profile = "devops"
}

resource "aws_s3_bucket" "test" {
  bucket = "test.ple.com"
  acl = "public-read"
  policy = "${file("policy.json")}"
  
  website {
    index_document = "index.html"
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "${aws_s3_bucket.test.website_endpoint}"
    origin_id = "testS3origin"
  }
  depends_on = [ "aws_s3_bucket.test" ]
}
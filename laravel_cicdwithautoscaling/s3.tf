resource "aws_s3_bucket" "laravel_cicd_artifacts" {
  bucket = "laravel-cicd-artifacts"
  tags = {
    Name = "laravel-cicd-artifacts"
  }
}

resource "aws_s3_object" "laravel_configs" {
  bucket   = aws_s3_bucket.laravel_cicd_artifacts.id
  for_each = fileset("s3objects/", "*")
  key      = each.value
  source   = "s3objects/${each.value}"
}
output "state_bucket_name" {
  value       = aws_s3_bucket.state.id
  description = "terraform state bucket name (aka id)"
}

output "state_dynamodb_table_lock" {
  value       = aws_dynamodb_table.state_lock.id
  description = "terraform state dynamoDB table name (aka id)"
}

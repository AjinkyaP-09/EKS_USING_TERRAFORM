terraform {
  backend "s3" {
    # REPLACE with the actual bucket name you created in Step 1
    bucket         = "my-terraform-state-bucket-unique-12345-23122025"
    
    # This is the folder/file path inside the bucket
    key            = "eks-cluster/terraform.tfstate"
    
    region         = "ap-south-1"
    
    # REPLACE with the actual table name you created in Step 1
    dynamodb_table = "terraform-state-lock"
    
    encrypt        = true
  }
}

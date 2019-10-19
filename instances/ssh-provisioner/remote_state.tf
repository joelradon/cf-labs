data "terraform_remote_state" "instances" {
  backend = "s3"

  config = {
    bucket = var.instances_remote_state_bucket
    key    = var.instances_remote_state_key
    region = var.region
  }
}


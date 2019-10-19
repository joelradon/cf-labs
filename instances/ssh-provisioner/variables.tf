variable "region" {
  description = "AWS Region"
}

variable "instances_remote_state_bucket" {
  description = "Bucket name for layer 1 remote state"
}

variable "instances_remote_state_key" {
  description = "Key name for layer 1 remote state"
}

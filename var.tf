variable "ami_id" {
  default     = "ami-0e2612a08262410c8"
}

variable "instance_type" {
  default     = "t2.micro"
}

variable "server_port" {
  type        = number
  default     = "8080"
}
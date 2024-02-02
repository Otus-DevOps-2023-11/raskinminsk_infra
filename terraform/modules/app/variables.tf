variable "public_key_path" {
  description = "Path to the public key for ssh connect"
}
variable "subnet_id" {
  description = "Subnets for modules"
}
variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

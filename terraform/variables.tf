variable "cloud_id" {
  description = "My Cloud"
}
variable "folder_id" {
  description = "My Folder"
}
variable "zone" {
  description = "Default Zone"
  default     = "ru-central1-a"
}
variable "public_key_path" {
  description = "Path to the public key for ssh connect"
}
variable "image_id" {
  description = "Packer disk image"
}
variable "subnet_id" {
  description = "Network subnet"
}
variable "service_account_key_file" {
  description = "service account key json file"
}

variable "resource_group_name" {}
variable "region" {
	description = "Azure region"
}
variable "os_type" {
  description = "Operating system type"
  default     = "Windows"
}

variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(number)
  default     = [3389, 80, 443]  # Example ports, adjust as needed
}
variable "storage_account_prefix" {}

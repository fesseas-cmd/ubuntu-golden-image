variable "proxmox_url"      { default = "https://192.168.1.52:8006/api2/json" }
variable "proxmox_username" { default = "root@pam!packer" }
variable "proxmox_token" {
  type      = string
  sensitive = true
}
variable "proxmox_node"     { default = "proxmox" }
variable "proxmox_storage"  { default = "local-lvm" }
variable "ubuntu_iso"       { default = "local:iso/ubuntu-24.04.5-live-server-amd64.iso" }

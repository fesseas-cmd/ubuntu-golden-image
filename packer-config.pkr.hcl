packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.0"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu-golden" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  token                    = var.proxmox_token
  insecure_skip_tls_verify = true
  node                     = var.proxmox_node

  vm_id      = 9100
  vm_name    = "ubuntu-2404-golden"
  os         = "l26"
  cores      = 2
  memory     = 2048
  qemu_agent = true

  scsi_controller = "virtio-scsi-pci"
  disks {
    disk_size    = "20G"
    storage_pool = var.proxmox_storage
    type         = "scsi"
    format       = "raw"
  }
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  iso_file    = var.ubuntu_iso
  unmount_iso = true

  cloud_init              = true
  cloud_init_storage_pool = var.proxmox_storage

  http_directory = "http"
  boot_wait      = "10s"
  boot_command = [
    "c<wait3>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\"<enter><wait3>",
    "initrd /casper/initrd<enter><wait3>",
    "boot<enter>"
  ]

  ssh_username = "packer"
  ssh_password = "packer"
  ssh_timeout  = "30m"

  template_name = "ubuntu-2404-golden-v1"
}

build {
  sources = ["source.proxmox-iso.ubuntu-golden"]

  provisioner "shell" {
    execute_command = "sudo -E sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "./scripts/update-system.sh"
  }

  provisioner "shell" {
    inline            = ["sudo reboot"]
    expect_disconnect = true
  }

  provisioner "shell" {
    pause_before = "30s"
    inline       = ["echo \"Kernel en uso tras reboot: $(uname -r)\""]
  }

  provisioner "shell" {
    execute_command = "sudo -E sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "./scripts/cleanup.sh"
  }
}

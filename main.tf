terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
#    tls = {
#      source  = "hashicorp/tls"
#      version = "3.1.0"
#    }
  }
}

provider "libvirt" {
 #uri = "qemu:///system"
 uri = "qemu+ssh://robin@192.168.1.95/system?keyfile=/Users/r.mordasiewicz/.ssh/id_ed25519"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "ubuntu-jammy-cloud-image" {
 name   = "ubuntu-jammy-qcow2"
 pool   = "default"
 source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
 format = "qcow2"
}

resource "libvirt_volume" "ubuntu-image" {
  name           = "ubuntu-image"
  base_volume_id = libvirt_volume.ubuntu-jammy-cloud-image.id
  pool           = "default"
  size           = 10737418240
}

resource "libvirt_cloudinit_disk" "cloud-config" {
  name           = "cloud-config.iso"
  user_data      = templatefile("${path.module}/cloud-config.yml", {
  })
  pool           = "default"
}

resource "libvirt_domain" "ubuntu" {
 name   = "ubuntu"
 description = "Ubuntu 22.04"
 memory = "2048"
 #machine = "pc-q35-6.2"
 xml {
   xslt = file("machine.xsl")
 }
 vcpu = 2
 qemu_agent = true

 cloudinit = libvirt_cloudinit_disk.cloud-config.id

 network_interface {
  macvtap = "enp108s0"
#  wait_for_lease = true
 }

 #cpu {
 # mode = "host-passthrough"
 #}

 console {
   type        = "pty"
   target_port = "0"
   target_type = "serial"
 }

 console {
   type        = "pty"
   target_type = "virtio"
   target_port = "1"
 }

 disk {
   volume_id = libvirt_volume.ubuntu-image.id
 }

 graphics {
   type        = "spice"
   listen_type = "address"
   autoport    = "true"
 }
}

#provider "tls" {
#  // no config needed
#}

#resource "tls_private_key" "ssh" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}

#resource "local_sensitive_file" "pem_file" {
#  filename = pathexpand("~/.ssh/id_rsa")
#  file_permission = "600"
#  directory_permission = "700"
#  content = tls_private_key.ssh.private_key_pem
#}

#resource "local_file" "private_key" {
#  content         = tls_private_key.ssh.private_key_pem
#  filename        = "linode.pem"
#  file_permission = "0600"
#}

#output "ssh_private_key" {
#  value     = tls_private_key.ssh.private_key_pem
#  sensitive = true
#}

#output "ip" {
#  value = libvirt_domain.ubuntu.*.network_interface.0.addresses
#}

#output "ips" {
#  value = libvirt_domain.ubuntu.network_interface[0].addresses[0]
#}

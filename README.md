sudo apt install -y qemu-kvm  libvirt-daemon-system bridge-utils virtinst genisoimage libvirt-dev

uncomment security_driver = "none" in /etc/libvirt/qemu.conf and restart libvirtd service. (sudo systemctl restart libvirtd)

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor --yes -o githubcli.gpg

gpg  --keyring ./githubcli.gpg --no-default-keyring --export -a > key.asc


Check if the key you want to import is part of the Ubuntu key server:

Get the key ID from the public key
wget -qO- https://repos.influxdata.com/influxdb.key | gpg --with-fingerprint --with-colons | awk -F: '/^fpr/ { print $10 }'
Check if it can be retrieved from the Ubuntu keyserver
gpg --keyserver=keyserver.ubuntu.com --recv-keys 05CE15085FC09D18E99EFB22684A14CF2582E0C5
The key is present on the Ubuntu key server

apt:
  sources:
    influxdb:
      keyid: 05CE15085FC09D18E99EFB22684A14CF2582E0C5
      source: 'deb [signed-by=$KEY_FILE] https://repos.influxdata.com/ubuntu $REL


terraform destroy -auto-approve && terraform apply -auto-approve

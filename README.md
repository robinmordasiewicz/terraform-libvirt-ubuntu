sudo apt install -y qemu-kvm  libvirt-daemon-system bridge-utils virtinst genisoimage libvirt-dev

uncomment security_driver = "none" in /etc/libvirt/qemu.conf and restart libvirtd service. (sudo systemctl restart libvirtd)


curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor --yes -o githubcli.gpg

gpg  --keyring ./githubcli.gpg --no-default-keyring --export -a > key.asc

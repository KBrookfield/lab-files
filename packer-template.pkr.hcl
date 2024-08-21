source "vsphere-supervisor" "vm" {
  keep_input_artifact = true
  supervisor_namespace = "namespace-1"
  
  class_name = "best-effort-small"
  image_name = "vmi-06f1807c69d0c34e6"
  storage_class = "k8s-storage-policy"

  ssh_username = "packer"
  ssh_password = "packer"
  
  publish_location_name = "cl-7b45e7808b051c0d3"
  publish_image_name = "packer-image"
}

build {
  sources = ["source.vsphere-supervisor.vm"]

  provisioner "ansible" {
    playbook_file = "ntp-playbook.yml"
  }

  provisioner "ansible" {
    playbook_file = "ansible-user-playbook.yml"
  }
}

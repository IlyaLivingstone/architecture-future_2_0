# параметры dev; cloud_id, folder_id и subnet_id подставьте свои

zone           = "ru-central1-a"
vm_name        = "future20-vm-dev"
cores          = 2
ram_gb         = 4
boot_disk_gb   = 15
data_disk_name = "future20-disk-dev"
data_disk_gb   = 15

cloud_id  = "replace-with-cloud-id"
folder_id = "replace-with-folder-id"
subnet_id = "replace-with-subnet-id"

ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIReplaceWithYourOwnPublicKey dev@example"

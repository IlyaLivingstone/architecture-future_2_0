# параметры prod; cloud_id, folder_id и subnet_id подставьте свои

zone           = "ru-central1-a"
vm_name        = "future20-vm-prod"
cores          = 8
ram_gb         = 16
boot_disk_gb   = 40
data_disk_name = "future20-disk-prod"
data_disk_gb   = 80

cloud_id  = "replace-with-cloud-id"
folder_id = "replace-with-folder-id"
subnet_id = "replace-with-subnet-id"

ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIReplaceWithYourOwnPublicKey prod@example"

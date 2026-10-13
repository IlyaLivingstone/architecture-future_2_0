# параметры stage; cloud_id, folder_id и subnet_id подставьте свои

zone           = "ru-central1-b"
vm_name        = "future20-vm-stage"
cores          = 4
ram_gb         = 8
boot_disk_gb   = 25
data_disk_name = "future20-disk-stage"
data_disk_gb   = 40

cloud_id  = "replace-with-cloud-id"
folder_id = "replace-with-folder-id"
subnet_id = "replace-with-subnet-id"

ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIReplaceWithYourOwnPublicKey stage@example"

# EC2 インスタンスを作成した後に Ansible Playbook を実行する action の定義
# ref. https://danielmschmidt.de/posts/2025-09-26-terraform-actions-introduction/
# action "ansible_playbook" "common" {
#   config {
#     playbook_path  = "${path.root}/playbooks/roles/common/playbook.yaml"
#     host           = aws_eip.nginx.public_ip
#     ssh_public_key = data.aws_key_pair.mykey.public_key
#   }
# }

ansible-playbook -i inventory web.yaml
ansible-playbook -i inventory api.yaml
ansible-playbook -i inventory load_balancer.yaml
ansible-playbook -i inventory jenkins.yaml
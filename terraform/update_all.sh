ansible-playbook -i inventory ../ansible/web.yaml
ansible-playbook -i inventory ../ansible/api.yaml
ansible-playbook -i inventory ../ansible/load_balancer.yaml
ansible-playbook -i inventory ../ansible/jenkins.yaml
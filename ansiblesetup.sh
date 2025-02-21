#!/bin/bash
sudo apt-get update 
sudo apt install software-properties-common -y 
sudo add-apt-repository --yes --update ppa:ansible/ansible -y 
sudo apt install ansible -y 
ansible-playbook tomcat_setup.yaml

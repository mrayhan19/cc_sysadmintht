#!/bin/bash

# System Preparation
# To prevent error "bootstrap check failure [1] of [1]: max virtual memory areas vm.max_map_count is too low" I set the
# vm.max_map_count to 262144
# In case you want to apply the changes permanently, you can run: sudo sh -c "echo 'vm.max_map_count=262144' >> /etc/sysctl.conf" and the run: "sysctl -p"

sysctl -w vm.max_map_count=262144

# Start the sonarqube stack
docker compose up -d && docker compose ps &&echo -e '\n"Sonarqube Docker is started. To stop it, run "docker compose down"\n'



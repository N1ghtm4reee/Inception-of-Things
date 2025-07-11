#!/bin/bash

vagrant up

sleep 10

cd ./Ansible && ./ansible_run.sh
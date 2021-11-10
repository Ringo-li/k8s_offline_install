#!/bin/bash
sed -i  /^PasswordAuthentication/s/no/yes/ /etc/ssh/sshd_config
systemctl restart sshd

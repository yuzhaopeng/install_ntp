#!/bin/bash

############################### Function ##########################################

# 预先检查ansible是否安装
function pre_check(){
    echo "start check ansible if installed"
    rpm -qa | grep ansible
    if [ $? -eq 0 ];then
        echo "Ansible installed"
        return 0
    else
        echo "Ansible not exist, start install"
        yum install -y ansible
        return $?
    fi
}

# 帮助说明
function help(){
cat << EOF

USAGE:
    $0 command

COMMAND
    install 批量安装ntp服务
    uninstall   批量卸载ntp服务

EOF
}

# 安装ntp
function install_ntp(){
    pre_check
    if [ $? -eq 0 ];then
        ansible-playbook -i ./inventory/hosts --ssh-common-args "-o StrictHostKeyChecking=no" ./playbook/ntp_install.yaml
    else 
        echo "安装ntp失败，请检查"
        return 1
    fi
}

# 卸载ntp
function uninstall_ntp(){
    pre_check
    if [ $? -eq 0 ];then
        ansible-playbook -i ./inventory/hosts --ssh-common-args "-o StrictHostKeyChecking=no" ./playbook/ntp_uninstall.yaml
    else 
        echo "安装ntp失败，请检查"
        return 1
    fi
}

##############################  流程控制区  ############################################

if [ $# -ne 1 ]; then
    help
    exit
fi

case $1 in 
    install)
        install_ntp;;
    uninstall)
        uninstall_ntp;;
    *)
        help;;
esac
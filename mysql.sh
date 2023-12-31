source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "disabling mysql default version"
dnf module disable mysql -y &>>/tmp/roboshop.log
exit_status

print_head "coping mysql repo"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log
exit_status

print_head "installing mysql"
dnf install mysql-community-server -y &>>/tmp/roboshop.log
exit_status

print_head "enabling mysql service"
systemctl enable mysqld &>>/tmp/roboshop.log
exit_status

print_head "starting mysql service"
systemctl start mysqld &>>/tmp/roboshop.log
exit_status

print_head "setting mysql password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log
exit_status
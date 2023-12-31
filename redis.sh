source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "installing redis repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log
exit_status

print_head "enabling redis 6.2 version"
dnf module enable redis:remi-6.2 -y &>>/tmp/roboshop.log
exit_status

print_head "installing redis"
dnf install redis -y &>>/tmp/roboshop.log
exit_status

print_head "updating redis listening address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>/tmp/roboshop.log
exit_status

print_head "enabling redis service"
systemctl enable redis &>>/tmp/roboshop.log
exit_status

print_head "starting redis service"
systemctl start redis &>>/tmp/roboshop.log
exit_status
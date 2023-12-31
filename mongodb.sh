source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "coping mongodb repo"
cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
exit_status

print_head "installing mongodb"
dnf install mongodb-org -y  &>>/tmp/roboshop.log
exit_status

print_head "enabling mongod service"
systemctl enable mongod &>>/tmp/roboshop.log
exit_status

print_head "starting mongod service"
systemctl start mongod &>>/tmp/roboshop.log
exit_status

print_head "updating mongod listening address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>/tmp/roboshop.log
exit_status

print_head "restarting mongod service"
systemctl restart mongod &>>/tmp/roboshop.log
exit_status
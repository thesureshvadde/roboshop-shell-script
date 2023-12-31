source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "disabling nodejs default version"
dnf module disable nodejs -y &>>/tmp/roboshop.log
exit_status

print_head "enabling nodejs 18 version"
dnf module enable nodejs:18 -y &>>/tmp/roboshop.log
exit_status

print_head "installing nodejs"
dnf install nodejs -y &>>/tmp/roboshop.log
exit_status

print_head "adding application(roboshop) user"
id roboshop  &>>/tmp/roboshop.log
if [ $? -ne 0 ]; then
    useradd roboshop &>>/tmp/roboshop.log
fi
exit_status

print_head "creating application(/app) directory"
if [ ! -d /app ]; then # not directory /app
    mkdir /app &>>/tmp/roboshop.log
fi
exit_status

print_head "downloading cart code"
curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log
exit_status

print_head "changing to /app directory"
cd /app  &>>/tmp/roboshop.log
exit_status

print_head "unziping cart code"
unzip /tmp/cart.zip &>>/tmp/roboshop.log
exit_status

print_head "downloading dependinces"
npm install  &>>/tmp/roboshop.log
exit_status

print_head "coping cart service file"
cp ${code_dir}/configs/cart.service /etc/systemd/system/cart.service &>>/tmp/roboshop.log
exit_status

print_head "daemon reload"
systemctl daemon-reload &>>/tmp/roboshop.log
exit_status

print_head "enabling cart service"
systemctl enable cart &>>/tmp/roboshop.log
exit_status

print_head "starting cart service"
systemctl start cart &>>/tmp/roboshop.log
exit_status
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

print_head "downloading user code"
curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>/tmp/roboshop.log
exit_status

print_head "changing to /app directory"
cd /app  &>>/tmp/roboshop.log
exit_status

print_head "unziping user code"
unzip /tmp/user.zip &>>/tmp/roboshop.log
exit_status

print_head "downloading dependinces"
npm install  &>>/tmp/roboshop.log
exit_status

print_head "coping user service file"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>/tmp/roboshop.log
exit_status

print_head "daemon reload"
systemctl daemon-reload &>>/tmp/roboshop.log
exit_status

print_head "enabling user service"
systemctl enable user &>>/tmp/roboshop.log
exit_status

print_head "starting user service"
systemctl start user &>>/tmp/roboshop.log
exit_status

print_head "coping mongo repo"
cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
exit_status

print_head "installing mongo client"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log
exit_status

print_head "loading schema"
mongo --host mongodb.sureshdevops.online < /app/schema/user.js &>>/tmp/roboshop.log
exit_status

print_head "restarting user service"
systemctl restart user &>>/tmp/roboshop.log
exit_status
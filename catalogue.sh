source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "disabling nodejs default version"
dnf module disable nodejs -y &>>/tmp/roboshop.log
exit_status

print_head "enablimng nodejs 18 version"
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

print_head "downloading catalogue code"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
exit_status

print_head "changing to /app directory"
cd /app  &>>/tmp/roboshop.log
exit_status

print_head "unziping catalogue code"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
exit_status

print_head "downloading dependinces"
npm install  &>>/tmp/roboshop.log
exit_status

print_head "coping catalogue service file"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
exit_status

print_head "daemon reload"
systemctl daemon-reload &>>/tmp/roboshop.log
exit_status

print_head "enabling catalogue service"
systemctl enable catalogue &>>/tmp/roboshop.log
exit_status

print_head "starting catalogue service"
systemctl start catalogue &>>/tmp/roboshop.log
exit_status

print_head "coping mongo repo"
cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
exit_status

print_head "installing mongo client"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log
exit_status

print_head "loading schema"
mongo --host mongodb.sureshdevops.online < /app/schema/catalogue.js &>>/tmp/roboshop.log
exit_status

print_head "restarting catalogue service"
systemctl restart catalogue &>>/tmp/roboshop.log
exit_status
source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "installing maven(java)"
dnf install maven -y &>>/tmp/roboshop.log
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

print_head "downloading shipping code"
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
exit_status

print_head "changing to /app directory"
cd /app &>>/tmp/roboshop.log
exit_status

print_head "unziping shipping code"
unzip /tmp/shipping.zip &>>/tmp/roboshop.log
exit_status

print_head "changing to /app directory"
cd /app &>>/tmp/roboshop.log
exit_status

print_head "installing dependincies"
mvn clean package &>>/tmp/roboshop.log
exit_status

print_head "renaming and moving shipping.jar"
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log
exit_status

print_head "coping shipping service file"
cp ${code_dir}/configs/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log
exit_status

print_head "daemon reload"
systemctl daemon-reload &>>/tmp/roboshop.log
exit_status

print_head "enabling shipping service"
systemctl enable shipping  &>>/tmp/roboshop.log
exit_status

print_head "starting shipping service"
systemctl start shipping &>>/tmp/roboshop.log
exit_status

print_head "installing mysql client"
dnf install mysql -y &>>/tmp/roboshop.log
exit_status

print_head "loading schema"
mysql -h mysql.sureshdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>/tmp/roboshop.log
exit_status

print_head "restarting shipping service"
systemctl restart shipping &>>/tmp/roboshop.log
exit_status
source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "installing python"
dnf install python36 gcc python3-devel -y &>>/tmp/roboshop.log
exit_status

print_head "creating application(roboshop) user"
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

print_head "downloading payment code"
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log
exit_status

print_head "changing to /app directory"
cd /app  &>>/tmp/roboshop.log
exit_status

print_head "unziping payment code"
unzip /tmp/payment.zip &>>/tmp/roboshop.log
exit_status

print_head "changing to /app directory"
cd /app  &>>/tmp/roboshop.log
exit_status

print_head "installing dependincies"
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log
exit_status

print_head "coping payment service file"
cp ${code_dir}/configs/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log
exit_status

print_head "daemon reload"
systemctl daemon-reload &>>/tmp/roboshop.log
exit_status

print_head "enabling payment service"
systemctl enable payment  &>>/tmp/roboshop.log
exit_status

print_head "starting payment service"
systemctl start payment &>>/tmp/roboshop.log
exit_status
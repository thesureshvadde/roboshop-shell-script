source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "installing nginx"
dnf install nginx -y &>>/tmp/roboshop.log
exit_status

print_head "enabling nginx service"
systemctl enable nginx &>>/tmp/roboshop.log
exit_status

print_head "starting nginx service"
systemctl start nginx &>>/tmp/roboshop.log
exit_status

print_head "removing nginx default content"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
exit_status

print_head "downloading web code"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>/tmp/roboshop.log
exit_status

print_head "changing to /usr/share/nginx/html directory"
cd /usr/share/nginx/html &>>/tmp/roboshop.log
exit_status

print_head "unziping web code"
unzip /tmp/web.zip &>>/tmp/roboshop.log
exit_status

print_head "coping rboshop conf file"
cp ${code_dir}/configs/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>/tmp/roboshop.log
exit_status

print_head "restarting nginx service"
systemctl restart nginx  &>>/tmp/roboshop.log
exit_status
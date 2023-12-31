source common.sh
code_dir=$(pwd)
rm -f /tmp/roboshop.log 

print_head "installing erlang repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>/tmp/roboshop.log
exit_status

print_head "installing rabbitmq repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>/tmp/roboshop.log
exit_status

print_head "installing rabbitmq"
dnf install rabbitmq-server -y   &>>/tmp/roboshop.log
exit_status

print_head "enabling rabbitmq-server"
systemctl enable rabbitmq-server   &>>/tmp/roboshop.log
exit_status

print_head "starting rabbitmq-server"
systemctl start rabbitmq-server   &>>/tmp/roboshop.log
exit_status

print_head "adding roboshop as rabbitmq user"
rabbitmqctl add_user roboshop roboshop123  &>>/tmp/roboshop.log
exit_status

print_head "setting permissions to the roboshop user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>/tmp/roboshop.log
exit_status
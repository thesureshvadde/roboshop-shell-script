print_head() {
    echo -e "\e[36m $1 \e[0m"
}

exit_status() {
    if [ $? -eq 0 ]; then
        echo "SUCCESS"
    else
        echo "FAILURE"
        exit 1
    fi
}
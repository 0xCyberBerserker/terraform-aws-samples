  #!/bin/bash

 function co() {
        if [ $? != "0" ];  
        then 
                echo -e "\e[0;33mERR"
        else
                echo -e "\e[0;32mOK"
        fi
}

function check_prog() {
        sudo yum -y update
        echo "*** Updating Yum ***......[$(co)]"
        sudo yum upgrade -y
        echo "*** Upgrading Yum ***......[$(co)]"
        sudo yum install -y amazon-linux-extras
        echo "*** Installing amazon-linux-extras ***......[$(co)]"
        sudo yum -y install httpd php8.1.x86_64 php8.1-mysqlnd.x86_64 php8.1-cli.x86_64 php8.1-pdo.x86_64 php8.1-fpm.x86_64 wget 
        echo "*** Installing Dependencies ***......[$(co)]"
        sudo wget https://wordpress.org/latest.tar.gz
        echo "*** Downloading WordPress ***......[$(co)]"
        tar -xzvf latest.tar.gz
        echo "*** Extracting WordPress ***......[$(co)]"
        sudo mv wordpress/* /var/www/html/
        echo "*** Moving WordPress ***......[$(co)]"
        sudo cp /tmp/wp-config.php /var/www/html/wp-config.php
        echo "*** Copying wp-config.php ***......[$(co)]"
        sudo chown -R apache.apache /var/www/html
        echo "*** Changing ownership ***......[$(co)]"
        sudo systemctl start httpd
        echo "*** Starting Apache ***......[$(co)]"          
}

check_prog

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
        sudo amazon-linux-extras install php8.2
        echo "*** Installing amazon-linux-extras ***......[$(co)]"
        sudo yum -y install httpd wget jq
        echo "*** Installing Dependencies ***......[$(co)]"
        sudo usermod -a -G apache ec2-user
        echo "*** Adding ec2-user to apache ***......[$(co)]"
        sudo chown -R ec2-user:apache /var/www
        echo "*** Changing ownership ***......[$(co)]"
        sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
        echo "*** Changing permissions 1 ***......[$(co)]"
        find /var/www -type f -exec sudo chmod 0664 {} \;
        echo "*** Changing permissions 2 ***......[$(co)]"
        sudo wget https://wordpress.org/latest.tar.gz
        echo "*** Downloading WordPress ***......[$(co)]"
        tar -xzvf latest.tar.gz
        echo "*** Extracting WordPress ***......[$(co)]"
        sudo mv wordpress/* /var/www/html/
        echo "*** Moving WordPress ***......[$(co)]"
        sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
        echo "*** Copying wp-config.php ***......[$(co)]"
        ## Setting DB User
        WORDPRESS_DB_USER=$(aws ssm get-parameter --name /parameters/db_username --query 'Parameter.Value' --region us-west-2 | jq -r .)
        sed -i "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', '${WORDPRESS_DB_USER}' );/g" /var/www/html/wp-config.php
        ## Setting DB Host
        WORDPRESS_DB_HOST=$(aws ssm get-parameter --name /parameters/db_endpoint --query 'Parameter.Value' --region us-west-2 | jq -r .)
        sed -i "s/define( 'DB_HOST', '' );/define( 'DB_HOST', '${WORDPRESS_DB_HOST}' );/g" /var/www/html/wp-config.php
        ## Setting DB Name
        # WORDPRESS_DB_NAME=$(aws ssm get-parameter --name wordpress --query 'Parameter.Value' --region us-west-2 | jq -r .)
        sed -i "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', 'wordpress' );/g" /var/www/html/wp-config.php
        ## Setting DB Passwd
        WORDPRESS_DB_PASSWD=$(aws ssm get-parameter --name /parameters/db_password --query 'Parameter.Value' --region us-west-2 | jq -r .)
        sed -i "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', '${WORDPRESS_DB_PASSWD}' );/g" /var/www/html/wp-config.php
        echo "*** Setting wp-config.php with regular expressions***......[$(co)]"
        sudo systemctl start httpd
        echo "*** Starting Apache ***......[$(co)]"          
        sudo systemctl enable httpd
        echo "*** Enabling Apache ***......[$(co)]"

}
check_prog



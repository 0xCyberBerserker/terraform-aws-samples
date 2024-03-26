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
        sudo yum -y install httpd
        echo "*** Installing Apache ***......[$(co)]"
        sudo yum -y install php
        echo "*** Installing PHP ***......[$(co)]"
        sudo rm -rf /var/www/html/index.html
        echo "*** Removing index.html ***......[$(co)]"
        sudo echo "<?php phpinfo(); ?>" >> /var/www/html/index.php
        echo "*** Adding index.php ***......[$(co)]"
        sudo service httpd start
        echo "*** Restarting Apache ***......[$(co)]"
        chkconfig httpd on
        echo "*** Enabling Apache ***......[$(co)]"
}


check_prog




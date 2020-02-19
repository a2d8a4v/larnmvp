#!/bin/bash

#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

function setting_mariadb {
	## -- create account and database in maraidb
	# @https://mariadb.com/kb/zh-cn/setting-character-sets-and-collations/
    mysql -uroot -p${mariadbpasswd} -e "CREATE DATABASE ${dbname} CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    #mysql -uroot -p${mariadbpasswd} -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
    #mysql -uroot -p${mariadbpasswd} -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    # you can just use one line to approach the same effect.
    mysql -uroot -p${mariadbpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO ${ADMDBNAME}@'localhost' IDENTIFIED BY '${PASSWDDBNAME}';"
    mysql -uroot -p${mariadbpasswd} -e "FLUSH PRIVILEGES;"
    # @https://raw.githubusercontent.com/saadismail/useful-bash-scripts/master/db.sh

    if [[ ${IS_CUSTOM} == "no" ]];then
        echo "nothing to do."
    else
        ## -- improve the setting
        # for big database lead to big log files, we should set how long can log files be saved
        sed -i -e '\,\[mysqld\],  a \expire-logs-days=1' /etc/mysql/my.cnf
        service mysql restart
    fi
}

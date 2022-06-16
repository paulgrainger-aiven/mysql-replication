#!/bin/bash
AVN_SERVICE_NAME=${AVN_SERVICE_NAME:-mysql-demo}

docker-compose down
sudo rm -rf ./*/data

docker-compose up -d

sleep 10

REPLICA_USER_CMD='
  CREATE USER "repluser"@"%" IDENTIFIED BY "replpassword";
  GRANT REPLICATION SLAVE ON *.* TO "repluser"@"%";
  GRANT SELECT, PROCESS, EVENT ON *.* to "repluser"@"%";
  FLUSH PRIVILEGES;
'

docker-compose exec mysql_main sh -c "mysql -u root --password=mypassword -e '${REPLICA_USER_CMD}'"
docker-compose exec mysql_replica sh -c "mysql -u root --password=mypassword -e '${REPLICA_USER_CMD}'"

docker-ip() {
    docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}

MAIN_STATUS=`docker exec mysql_main sh -c 'mysql -u root --password=mypassword -e "SHOW MASTER STATUS"'`
CURRENT_LOG=`echo $MAIN_STATUS | awk '{print $6}'`
CURRENT_POS=`echo $MAIN_STATUS | awk '{print $7}'`

START_REPLICA="mysql -u root --password=mypassword -e \"CHANGE MASTER TO MASTER_HOST='$(docker-ip mysql_main)',MASTER_USER='repluser', MASTER_PASSWORD='replpassword', MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS;START SLAVE;\""
docker-compose exec mysql_replica sh -c "${START_REPLICA}"

avn service update \
    -c migration.host=$(curl ifconfig.me) \
    -c migration.port=3306 \
    -c migration.username=repluser \
    -c migration.password=replpassword \
    -c migration.ssl=true \
    $AVN_SERVICE_NAME



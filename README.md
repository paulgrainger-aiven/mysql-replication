# Install dependencies
```
sudo apt update
sudo apt install -y git docker docker-compose python3-pip
pip3 install aiven-client
```

# Start Aiven for MySQL

[Create an API Token](https://developer.aiven.io/docs/platform/howto/create_authentication_token)

[Authenticate on CLI with token](https://developer.aiven.io/docs/tools/cli.html#authenticate)

Ensure after you login, that you are in the correct project

```
avn project switch my-project
```

Execute the following commands, changing the values for the cloud/plan/name you wish to use
```
AVN_SERVICE_PLAN=startup-4
AVN_SERVICE_CLOUD=do-sfo
AVN_SERVICE_NAME=mysql-demo

avn service create \
  --service-type mysql \
  --plan $AVN_SERVICE_PLAN \
  --cloud $AVN_SERVICE_CLOUD \
  --no-project-vpc \
  $AVN_SERVICE_NAME

```

# Intitiate replication 

This test will initiate live replication from the replica, to the Aiven for MySQL instance. 

Once the above is run, you can simply run 

```
./run.sh
```

If you chose to name your service something other than mysql-demo, execute it as

```
AVN_SERVICE_NAME=my-mysql-service-name ./run.sh
```

This script will use docker-compose to bring up a local MySQL main and replica. It will then initiate the connection to the Aiven service. 

Once complete, you can test by connecting to the main instance, and generating some data, for example:
```
docker-compose exec mysql_main mysql -u root --password=mypassword
create database db_1;
create table db_1.mytab(col1 int, col2 text);
insert into db_1.mytab(col1, col2) values (1, 'abc');
insert into db_1.mytab(col1, col2) values (2, 'xyz');
```
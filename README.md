# Install dependencies
```
sudo apt update
sudo apt install -y git docker docker-compose python3-pip
pip3 install aiven-client
```

Execute on main MySQL
```
docker-compose exec mysql_main mysql -u root -p

create database db_1;
create table db_1.mytab(col1 int, col2 text);
insert into db_1.mytab(col1, col2) values (1, 'abc');
insert into db_1.mytab(col1, col2) values (2, 'xyz');
```

Execute on replica
```
docker-compose exec mysql_replica mysql -u root -p

create user 'repl'@'%' identified by 'password';
grant replication slave on *.* to 'repl'@'%';
grant select, process, event on *.* to 'paul'@'%';


# Start Aiven for MySQL


```
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


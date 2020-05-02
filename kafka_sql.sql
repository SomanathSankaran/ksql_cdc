---step1 : Installing debeziun connector
--step2 : find $CONFLUENT_HOME -name kafka-connect-jdbc\*jar

--step 3: download plugin from https://debezium.io/documentation/reference/install.html

--step 4 : grant full permission to user 
--  GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'kafka_sql'@'localhost'  IDENTIFIED BY 'Ksql123456$';
--FLUSH PRIVILEGES;

--service mysql restart --log-bin=mysql-bin
drop CONNECTOR currency_rate_source

DESCRIBE CONNECTOR currency_rate_source
 CREATE SOURCE CONNECTOR currency_rate_source WITH(
     'connector.class'= 'io.debezium.connector.mysql.MySqlConnector',
        'tasks.max'= '1',
        'database.hostname'= 'localhost',
        'database.port'= '3306',
        'database.user'= 'test_user',
        'database.password'= 'Ksql123456$',
        'database.server.id'= '1123',
        'database.server.name'= 'MYSQL_cur_server',
         'table.whitelist'= 'currency_rate.exchange_rates',
        'database.history.kafka.bootstrap.servers'= 'localhost:9092',
        'database.history.kafka.topic'= 'currency_rate.exchange_rates_history',
         
       
        'key.converter'= 'org.apache.kafka.connect.json.JsonConverter',
        'key.converter.schemas.enable'= 'false',
        'value.converter'= 'org.apache.kafka.connect.json.JsonConverter',
        'value.converter.schemas.enable'= 'false',
        'decimal.handling.mode'='double',
		
        'transforms'= 'unwrap',
        'transforms.unwrap.type'= 'io.debezium.transforms.ExtractNewRecordState');
        
        
 
        print `MYSQL_cur_server.currency_rate.exchange_rates` limit  5;

DROP TABLE exchange_rates;

SET 'auto.offset.reset'='earliest';



CREATE TABLE exchange_rates (
  id integer,
  from_currency string,
  to_currency string,
  exchange_rates double,
  date_time string
)   WITH (KAFKA_TOPIC='MYSQL_cur_server.currency_rate.exchange_rates',VALUE_FORMAT='json');

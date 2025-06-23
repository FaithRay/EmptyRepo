

conda install -y  -n pz -c conda-forge


1. redis
wget https://download.redis.io/releases/redis-7.0.12.tar.gz

sudo dnf update -y
sudo dnf module list redis
sudo dnf install redis -y

sudo systemctl start redis

# 设置 Redis 服务开机自启
sudo systemctl enable redis

# 检查 Redis 服务的状态
sudo systemctl status redis

/etc/redis.conf





wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz

#wget https://archive.apache.org/dist/kafka/3.7.0/kafka_2.13-3.7.0.tgz
wget https://archive.apache.org/dist/kafka/2.8.1/kafka_2.12-2.8.1.tgz

cd /opt/kafka
sudo tar -xvzf kafka_2.12-2.8.1.tgz --strip 1


sudo mkdir -p /var/lib/zookeeper

# Edit ZooKeeper configuration file
sudo vi /opt/kafka/config/zookeeper.properties
   dataDir=/var/lib/zookeeper

mkdir -p /var/lib/kafka
vi /opt/kafka/config/server.properties
   broker.id=0
   log.dirs=/var/lib/kafka
   zookeeper.connect=localhost:2181

add export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk  before    
   /opt/kafka/bin/zookeeper-server-start.sh


sudo vi /etc/systemd/system/zookeeper.service
	[Unit]
	Description=Apache ZooKeeper Server
	Documentation=http://zookeeper.apache.org/
	Requires=network.target remote-fs.target
	After=network.target remote-fs.target

	[Service]
	Type=simple
	User=kafkauser  # Create this user in the next step
	Group=kafkauser # Create this group in the next step
	Environment="JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk" # Ensure this matches your Java 8 path
	ExecStart=/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties
	ExecStop=/opt/kafka/bin/zookeeper-server-stop.sh
	Restart=on-abnormal

	[Install]
	WantedBy=multi-user.target

/etc/systemd/system/kafka.service
    [Unit]
	Description=Apache Kafka Server
	Documentation=http://kafka.apache.org/documentation.html
	Requires=zookeeper.service
	After=zookeeper.service

	[Service]
	Type=simple
	User=kafkauser # Ensure this matches the user created below
	Group=kafkauser # Ensure this matches the group created below
	Environment="JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk" # Ensure this matches your Java 8 path
	ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
	ExecStop=/opt/kafka/bin/kafka-server-stop.sh
	Restart=on-abnormal

	[Install]
	WantedBy=multi-user.target


add kafka user
    sudo groupadd kafkauser
	sudo useradd -r -g kafkauser -s /sbin/nologin kafkauser
	sudo chown -R kafkauser:kafkauser /opt/kafka
	sudo chown -R kafkauser:kafkauser /var/lib/zookeeper
	sudo chown -R kafkauser:kafkauser /var/lib/kafka

start zookeeper and kafka

    sudo systemctl daemon-reload
	sudo systemctl start zookeeper
	sudo systemctl enable zookeeper
	sudo systemctl start kafka
	sudo systemctl enable kafka

kakfa create topic
    /opt/kafka/bin/kafka-topics.sh --create --topic my-test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

kafka list topic
    /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

    

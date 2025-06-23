#install redis

echo "start installing redis"
dnf update -y
dnf groupinstall "Development Tools" -y 
dnf install tcl -y 


REDIS_PACKAGE=redis-7.0.12

cd /tmp/
wget https://download.redis.io/releases/${REDIS_PACKAGE}.tar.gz
tar -xzf ${REDIS_PACKAGE}.tar.gz
cd ${REDIS_PACKAGE}

make
make install

adduser --system --no-create-home --shell /sbin/nologin redis
mkdir /etc/redis
mkdir -p /var/lib/redis
chown redis:redis /var/lib/redis
chmod 770 /var/lib/redis # Adjust permissions as needed for security vs. convenience
mkdir -p /var/log/redis # For Redis logs
chown redis:redis /var/log/redis

cp /tmp/${REDIS_PACKAGE}/redis.conf /etc/redis/


vi /etc/redis/redis.conf

daemonize no -> daemonize yes: This makes Redis run as a background process.
supervised no -> supervised systemd: Integrates with systemd for better management.
pidfile /var/run/redis_6379.pid: Ensure this line exists and points to a valid path.
logfile "" -> logfile "/var/log/redis/redis.log": Specify a log file path.
dir ./ -> dir /var/lib/redis: Set the data directory for persistence.
bind 127.0.0.1 -::1: By default, Redis listens only on localhost (IPv4 and IPv6). If you need to access it from other machines, you'll need to change this to 0.0.0.0 or a specific IP address (be cautious with security!).
protected-mode yes: Keep this as yes unless you explicitly need to disable it and have strong firewall rules.
requirepass your_strong_password: Highly recommended for production! Set a strong password for Redis access.


cp /tmp/redis-7.0.12/systemd/redis.service /etc/systemd/system/

vi  /etc/systemd/system/redis.service

```
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
WorkingDirectory=/var/lib/redis
Restart=always
Type=forking
PIDFile=/var/run/redis_6379.pid
TimeoutStartSec=1
LimitNOFILE=65535 # Recommended for production Redis servers

[Install]
WantedBy=multi-user.target
```


systemctl daemon-reload
systemctl start redis
systemctl enable redis


systemctl status redis


firewall-cmd --add-port=6379/tcp --permanent
firewall-cmd --reload




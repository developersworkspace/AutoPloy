python autoploy.py -i 198.199.83.9 -u root -p MidericK96 -r /root/builds -n Redis7001 -a "-p 7001:7001 -p 17001:17001" Templates/Redis/cluster/7001
python autoploy.py -i 198.199.83.9 -u root -p MidericK96 -r /root/builds -n Redis7002 -a "-p 7002:7002 -p 17002:17002" Templates/Redis/cluster/7002
python autoploy.py -i 198.199.83.9 -u root -p MidericK96 -r /root/builds -n Redis7003 -a "-p 7003:7003 -p 17003:17003" Templates/Redis/cluster/7003
python autoploy.py -i 198.199.83.9 -u root -p MidericK96 -r /root/builds -n Redis7004 -a "-p 7004:7004 -p 17004:17004" Templates/Redis/cluster/7004
python autoploy.py -i 198.199.83.9 -u root -p MidericK96 -r /root/builds -n Redis7005 -a "-p 7005:7005 -p 17005:17005" Templates/Redis/cluster/7005
python autoploy.py -i 198.199.83.9 -u root -p MidericK96 -r /root/builds -n Redis7006 -a "-p 7006:7006 -p 17006:17006" Templates/Redis/cluster/7006



python executeSsh.py -i 198.199.83.9 -u root -p MidericK96 -c "curl -o /tmp/redis-stable.tar.gz http://download.redis.io/redis-stable.tar.gz"
python executeSsh.py -i 198.199.83.9 -u root -p MidericK96 -c "apt-get -y install ruby"
python executeSsh.py -i 198.199.83.9 -u root -p MidericK96 -c "gem install redis"
python executeSsh.py -i 198.199.83.9 -u root -p MidericK96 -c "echo yes | /tmp/redis-stable/src/redis-trib.rb create --replicas 1 198.199.83.9:7001 198.199.83.9:7002 198.199.83.9:7003 198.199.83.9:7004 198.199.83.9:7005 198.199.83.9:7006"
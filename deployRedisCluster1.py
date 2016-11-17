import sys, os.path
sys.path.append(os.path.abspath('./src'))

from autoploy_systemdService import deploySystemDService
from base import executeSsh, getSsh, copyFileFromLocalToRemote, getSFtp
from pathlib import Path
from optparse import OptionParser
from time import sleep
from tempfile import gettempdir
from uuid import uuid4


# python deployRedisCluster1.py -u root -p Eur0m0nit0r "192.168.46.228 192.168.46.241 192.168.46.242"
# python deployRedisCluster1.py -u root -p Eur0m0nit0r "172.24.40.6 172.24.40.23 172.24.40.24"

currentPath = str(Path(__file__).parent)



def createRedisConfFile(port):
    filename = os.path.join(gettempdir(), str(uuid4())).replace('\\','/')
    f = open(filename, 'w+')
    f.write('port {0}\r\n'.format(port))
    f.write('bind 0.0.0.0\r\n')
    f.write('cluster-enabled yes\r\n')
    f.write('cluster-config-file node{0}.conf\r\n'.format(port))
    f.write('cluster-node-timeout 5000\r\n')
    f.write('appendonly yes\r\n')
    f.write('maxmemory 1024mb\r\n')
    f.write('maxmemory-policy volatile-ttl')

    f.close()

    return filename

def deployNodesToServer(username, password, ipAddress):
    ssh = getSsh(ipAddress, username, password)
    sftp = getSFtp(ipAddress, username, password)

    executeSsh(ssh, 'apt-get update')
    executeSsh(ssh, 'apt-get install -y redis-server', ignoreErrors = True)
    executeSsh(ssh, 'apt-get install -y tcl8.5', ignoreErrors = True)
    executeSsh(ssh, 'apt-get install -y build-essential', ignoreErrors = True)
    executeSsh(ssh, 'apt-get install -y wget', ignoreErrors = True)
    executeSsh(ssh, 'apt-get install -y make', ignoreErrors = True)
    executeSsh(ssh, 'wget http://download.redis.io/releases/redis-stable.tar.gz', ignoreErrors = True)
    executeSsh(ssh, 'tar xzf redis-stable.tar.gz')
    executeSsh(ssh, 'make -C /root/redis-stable', ignoreErrors = True)
    executeSsh(ssh, 'make -C /root/redis-stable install', ignoreErrors = True)

    for x in ['7001', '7002', '7003', '7004', '7005', '7006', '7007', '7008', '7009']:
        filename = createRedisConfFile(x)
        copyFileFromLocalToRemote(sftp, filename, '/etc/redis/redis{0}.conf'.format(x))
   

def deployClusterTools(username, password, ipAddress):

    ssh = getSsh(ipAddress, username, password)
    executeSsh(ssh, 'curl -o /tmp/redis-stable.tar.gz http://download.redis.io/redis-stable.tar.gz', True)
    executeSsh(ssh, 'tar xzvf /tmp/redis-stable.tar.gz -C /tmp')
    executeSsh(ssh, 'apt-get -y install ruby', True)
    executeSsh(ssh, 'gem install redis')
    
def clusterAllNodes(username, password, ipAddress, ipAddresses):
    ssh = getSsh(ipAddress, username, password)
    nodes = []
    for ip in ipAddresses:
        nodes.append('{0}:{1}'.format(ip, '7001'))
        nodes.append('{0}:{1}'.format(ip, '7002'))
        nodes.append('{0}:{1}'.format(ip, '7003'))
        nodes.append('{0}:{1}'.format(ip, '7004'))
        nodes.append('{0}:{1}'.format(ip, '7005'))
        nodes.append('{0}:{1}'.format(ip, '7006'))
        nodes.append('{0}:{1}'.format(ip, '7007'))
        nodes.append('{0}:{1}'.format(ip, '7008'))
        nodes.append('{0}:{1}'.format(ip, '7009'))

    executeSsh(ssh, 'echo yes | /tmp/redis-stable/src/redis-trib.rb create --replicas 2 {0}'.format(' '.join(nodes)))
    
if __name__ == "__main__":


    parser = OptionParser()

    parser.add_option("-u", "--username", dest="username",
                    help="SSH username of server")
    parser.add_option("-p", "--password", dest="password",
                    help="SSH password of server")

    (options, args) = parser.parse_args()

    username = options.username
    password = options.password
    ipAddresses = args[0].split(' ')

    for ipAddress in ipAddresses:
        deployNodesToServer(username, password, ipAddress)
        ssh = getSsh(ipAddress, username, password)
        
        for x in ['7001', '7002', '7003', '7004', '7005', '7006', '7007', '7008', '7009']:
            # executeSsh(ssh, '(crontab -l 2>/dev/null; echo "@reboot /usr/bin/redis-server /etc/redis/redis{0}.conf") | crontab -'.format(x))
            pass
            
        executeSsh(ssh, 'sudo reboot')

    print('Waiting for servers...')
    sleep(60)
    deployClusterTools(username, password, ipAddresses[0])
    clusterAllNodes(username, password, ipAddresses[0], ipAddresses)

     
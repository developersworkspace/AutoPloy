from autoploy import deploy
from base import executeSsh, getSsh



def deployNodesToServer(username, password, ipAddress):
    deploy('redis7001', ipAddress, username, password, '/root/builds', '-p 7001:7001 -p 17001:17001', 'Templates/Redis/cluster/7001')
    deploy('redis7002', ipAddress, username, password, '/root/builds', '-p 7002:7002 -p 17002:17002', 'Templates/Redis/cluster/7002')
    deploy('redis7003', ipAddress, username, password, '/root/builds', '-p 7003:7003 -p 17003:17003', 'Templates/Redis/cluster/7003')
    deploy('redis7004', ipAddress, username, password, '/root/builds', '-p 7004:7004 -p 17004:17004', 'Templates/Redis/cluster/7004')
    deploy('redis7005', ipAddress, username, password, '/root/builds', '-p 7005:7005 -p 17005:17005', 'Templates/Redis/cluster/7005')
    deploy('redis7006', ipAddress, username, password, '/root/builds', '-p 7006:7006 -p 17006:17006', 'Templates/Redis/cluster/7006')

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

    executeSsh(ssh, 'echo yes | /tmp/redis-stable/src/redis-trib.rb create --replicas 1 {0}'.format(' '.join(nodes)))
    
if __name__ == "__main__":
    username = 'root'
    password = 'MidericK96'
    ipAddresses = ['159.203.140.169']

    for ipAddress in ipAddresses:
         deployNodesToServer(username, password, ipAddress)

    deployClusterTools(username, password, ipAddresses[0])
    clusterAllNodes(username, password, ipAddresses[0], ipAddresses)
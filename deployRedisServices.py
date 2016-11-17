import sys, os.path
sys.path.append(os.path.abspath('./src'))

from autoploy_systemdService import deploySystemDService
from pathlib import Path
from optparse import OptionParser

currentPath = str(Path(__file__).parent)

    
if __name__ == "__main__":


    parser = OptionParser()

    parser.add_option("-i", "--host", dest="host",
                    help="Hostname or IP Address of server")
    parser.add_option("-u", "--username", dest="username",
                    help="SSH username of server")
    parser.add_option("-p", "--password", dest="password",
                    help="SSH password of server")

    (options, args) = parser.parse_args()

    host = options.host
    username = options.username
    password = options.password
    redisDockerContainers = args[0].split(' ')

    for x in redisDockerContainers:
        deploySystemDService('docker-{0}'.format(x), host, username, password, 'Redis Container', 'docker.service', 'docker.service', '/usr/bin/docker start -a {0}'.format(x), '/usr/bin/docker stop -t 2 redis_server'.format(x))
import sys, os
sys.path.append(os.path.abspath('./src'))

from optparse import OptionParser
from base import getSsh, getSFtp, executeSsh, copyFromLocalToRemote

def deployDockerContainer(name, host, username, password, remoteBuildPath, args, dockerPath):
    print('Connecting to remote server')
    ssh = getSsh(host, username, password)
    sftp = getSFtp(host, username, password)
    print('Connected')

    copyFromLocalToRemote(ssh, sftp, dockerPath, os.path.join(remoteBuildPath, name).replace('\\','/'))

    # executeSsh(ssh, 'docker build -t "{0}:tag" --no-cache {1}'.format(name, os.path.join(remoteBuildPath, name).replace('\\','/')))
    executeSsh(ssh, 'docker build -t "{0}:tag" {1}'.format(name, os.path.join(remoteBuildPath, name).replace('\\','/')))
    executeSsh(ssh, 'docker kill {0}'.format(name), True)
    executeSsh(ssh, 'docker rm {0}'.format(name), True)
    executeSsh(ssh, 'docker run -d --name "{0}" {1} -t "{0}:tag"'.format(name, args))

    print('Closing connection to remote server')
    ssh.close()
    sftp.close()

if __name__ == "__main__":
    parser = OptionParser()

    parser.add_option("-i", "--host", dest="host",
                    help="Hostname or IP Address of server")
    parser.add_option("-u", "--username", dest="username",
                    help="SSH username of server")
    parser.add_option("-p", "--password", dest="password",
                    help="SSH password of server")
    parser.add_option("-r", "--remotebuildpath", dest="remoteBuildPath",
                    help="Build path on server")
    parser.add_option("-a", "--args", dest="args", default = '',
                    help="Additional arguments when running docker container")
    parser.add_option("-n", "--name", dest="name",
                    help="Name of docker container")

    (options, args) = parser.parse_args()

    host = options.host
    username = options.username
    password = options.password
    dockerPath = args[0]
    remoteBuildPath = options.remoteBuildPath
    name = options.name.lower()
    a = options.args

    deployDockerContainer(name, host, username, password, remoteBuildPath, a, dockerPath)

    

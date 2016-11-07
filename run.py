import paramiko
import sys
import os
import uuid
from optparse import OptionParser

def getSsh(host, username, password):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host, username = username, password = password)
    return ssh

def getSFtp(host, username, password):
    transport = paramiko.Transport((host, 22))
    transport.connect(username = username, password = password)
    sftp = paramiko.SFTPClient.from_transport(transport)
    return sftp

def executeSsh(ssh, command, ignoreErrors = False):
    print('Executing {0}'.format(command))
    stdin, stdout, stderr = ssh.exec_command(command)
    text = stderr.read()
    if (text != b'' and ignoreErrors == False):
        print(text)
        raise Exception

def listLocalDirectories(path):
    return [d for d in os.listdir(path) if os.path.isdir(os.path.join(path, d))]

def listLocalFiles(path):
    return [d for d in os.listdir(path) if os.path.isfile(os.path.join(path, d))]

def copyFromLocalToRemote(localDirectory, remoteDirectory):

    p = os.path.join(remoteBuildPath, buildId).replace('\\', '/')
    print('Creating directory {0}'.format(p))
    ssh.exec_command('mkdir -p {0}'.format(p))

    for directory in listLocalDirectories(localDirectory):
        p = os.path.join(remoteBuildPath, buildId, directory).replace('\\', '/')
        print('Creating directory {0}'.format(p))
        ssh.exec_command('mkdir -p {0}'.format(p))

        copyFromLocalToRemote(os.path.join(localDirectory, directory).replace('\\', '/'), p)
        
    for file in listLocalFiles(localDirectory):
        sourcePath = os.path.join(localDirectory, file).replace('\\', '/')
        destinationPath = os.path.join(remoteDirectory, file).replace('\\', '/')

        print('Copying {0} to {1}'.format(sourcePath, destinationPath))
        sftp.put(sourcePath, destinationPath)
    

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

(options, args) = parser.parse_args()
print(options.host)

host = options.host
username = options.username
password = options.password

dockerPath = args[0]
remoteBuildPath = options.remoteBuildPath
buildId = str(uuid.uuid4())

ssh = getSsh(host, username, password)
sftp = getSFtp(host, username, password)

copyFromLocalToRemote(dockerPath, os.path.join(remoteBuildPath, buildId).replace('\\','/'))

executeSsh(ssh, 'docker build -t "{0}:tag" {1}'.format(buildId, os.path.join(remoteBuildPath, buildId).replace('\\','/')))
executeSsh(ssh, 'docker kill "{0}:tag"'.format(buildId), True)
executeSsh(ssh, 'docker rm "{0}:tag"'.format(buildId), True)
executeSsh(ssh, 'docker run -d --name "{0}" -t "{0}:tag"'.format(buildId))

ssh.close()
sftp.close()

# python run.py -i 198.199.83.9 -u root -p MidericK96 -r /root/builds Template/Nginx


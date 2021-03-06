import paramiko
import sys
import os

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

def copyFromLocalToRemote(ssh, sftp, localDirectory, remoteDirectory):

    p = remoteDirectory.replace('\\', '/')
    print('Creating directory {0}'.format(p))
    ssh.exec_command('mkdir -p {0}'.format(p))

    for directory in listLocalDirectories(localDirectory):
        destinationDirectory = os.path.join(remoteDirectory, directory).replace('\\', '/')
        sourceDirectory = os.path.join(localDirectory, directory).replace('\\', '/')

        print('Copying Directory {0} to {1}'.format(sourceDirectory, destinationDirectory))
        copyFromLocalToRemote(ssh, sftp, sourceDirectory, destinationDirectory)
        
    for file in listLocalFiles(localDirectory):
        sourcePath = os.path.join(localDirectory, file).replace('\\', '/')
        destinationPath = os.path.join(remoteDirectory, file).replace('\\', '/')

        print('Copying File {0} to {1}'.format(sourcePath, destinationPath))
        sftp.put(sourcePath, destinationPath)
    
def copyFileFromLocalToRemote(sftp, localFilename, remoteFilename):
    print('Copying File {0} to {1}'.format(localFilename, remoteFilename))
    sftp.put(localFilename, remoteFilename)



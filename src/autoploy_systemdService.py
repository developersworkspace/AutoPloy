from optparse import OptionParser
from base import getSsh, getSFtp, executeSsh, copyFileFromLocalToRemote
import sys
import os
from tempfile import gettempdir
from uuid import uuid4

def createSystemdServiceFile(name, description, requires, after, start, stop):
    filename = os.path.join(gettempdir(), str(uuid4())).replace('\\','/')
    f = open(filename, 'w+')
    f.write('[Unit]\r\n')
    f.write('Description={0}\r\n'.format(description))
    f.write('Requires={0}\r\n'.format(requires))
    f.write('After={0}\r\n'.format(after))
    f.write('\r\n')
    f.write('[Service]\r\n')
    f.write('Restart=always\r\n')
    f.write('ExecStart={0}\r\n'.format(start))
    f.write('ExecStop={0}\r\n'.format(stop))
    f.write('\r\n')
    f.write('[Install]\r\n')
    f.write('WantedBy=multi-user.target')

    f.close()

    return filename

def deploySystemDService(name, host, username, password, description, requires, after, start, stop):
    print('Connecting to remote server')
    ssh = getSsh(host, username, password)
    sftp = getSFtp(host, username, password)
    print('Connected')

    filename = createSystemdServiceFile(name, description, requires, after, start, stop)
    copyFileFromLocalToRemote(sftp, filename, os.path.join('/etc/systemd/system','{0}.service'.format(name)).replace('\\','/'))
    executeSsh(ssh, 'systemctl daemon-reload')
    executeSsh(ssh, 'systemctl start {0}.service'.format(name))
    executeSsh(ssh, 'systemctl enable {0}.service'.format(name), ignoreErrors = True)

if __name__ == "__main__":
    parser = OptionParser()

    parser.add_option("-i", "--host", dest="host",
                    help="Hostname or IP Address of server")
    parser.add_option("-u", "--username", dest="username",
                    help="SSH username of server")
    parser.add_option("-p", "--password", dest="password",
                    help="SSH password of server")
    parser.add_option("-d", "--description", dest="description",
                    help="Description of systemd service")
    parser.add_option("-r", "--requires", dest="requires", default = '')
    parser.add_option("-a", "--after", dest="after", default = '')
    parser.add_option("-s", "--start", dest="start")
    parser.add_option("-e", "--stop", dest="stop")
    parser.add_option("-n", "--name", dest="name",
                    help="Name of systemd service")

    host = options.host
    username = options.username
    password = options.password
    name = options.name.lower()
    description = options.description
    requires = options.requires
    after = options.after
    start = options.start
    stop = options.stop

    deploySystemDService(name, host, username, password, description, requires, after, start, stop)    

    
        
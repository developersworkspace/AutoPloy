from base import executeSsh, getSsh
from optparse import OptionParser

if __name__ == "__main__":
    parser = OptionParser()

    parser.add_option("-i", "--host", dest="host",
                    help="Hostname or IP Address of server")
    parser.add_option("-u", "--username", dest="username",
                    help="SSH username of server")
    parser.add_option("-p", "--password", dest="password",
                    help="SSH password of server")
    parser.add_option("-c", "--command", dest="command",
                    help="Ssh command to execute")

    (options, args) = parser.parse_args()

    host = options.host
    username = options.username
    password = options.password
    command = options.command

    ssh = getSsh(host, username, password)
    executeSsh(ssh, command)
    

    


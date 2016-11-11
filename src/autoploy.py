from optparse import OptionParser
from base import deploy

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
    args = options.args

    deploy(name, host, username, password, remoteBuildPath, args, dockerPath)

    

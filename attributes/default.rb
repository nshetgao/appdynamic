default[:appdynamics][:access_key]= "xh6o4ql3uebcztn5144"
default[:appdynamics][:controller_host]= "Angel.saas.appdynamics.com"

#Should obviously be overwritten in different environments that have different resources
default[:appdynamics][:application_name]= "angel-dc1"


default[:appdynamics][:controller][:fqdn]= "dc1-qe-appdynamics-01"

default[:appdynamics][:controller][:dir] = "/var/appdynamics"
default[:appdynamics][:controller][:port]="8080"
default[:appdynamics][:controller][:ssl_port]="443"
default[:appdynamics][:controller][:version]="3.1.3"
#Should figure out how to easily make the server here be from the environment
default[:appdynamics][:controller][:install][:url]="http://dc1-dev-build-02/downloads/controller_64bit_linux_v3.1.3.sh"

#This can be partial when doing a remote_file
default[:appdynamics][:controller][:install][:sha]="50078426e88dd47f0"
default[:appynamics][:controller][:passwordMD5]="$1$VPAFKmLG$fBX77DJbQNbpaCkp7DSAO/"

#TOTO this should be in an encrypted data bag

default[:appynamics][:controller][:password]="AngelR0cks"

default[:appynamics][:controller][:passwordMD5]="$1$VPAFKmLG$fBX77DJbQNbpaCkp7DSAO/"
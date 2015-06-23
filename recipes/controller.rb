# automation of http://docs.appdynamics.com/pages/viewpage.action?pageId=3212836


package "jdk" 


#Generate's a secure_password
# include Opscode::OpenSSL::Password
# 
# set_unless[:appynamics][:controller][:password] = secure_password
#Used int eh config var file

group "appdynamics"

#Need this gem to set shadow passwords, which is the only way to do it in a recipe
#and need ruby-devle to build the gem
# Of course, this is probably overkill . . .
# package "ruby-devel"
# 
# 
# gem_package "ruby-shadow"
# 
# user "appdynamics" do
#   password node[:appynamics][:controller][:passwordMD5]
#   group "appdynamics"
# end

# user "appdynamics" do
#   password 
#   
# end

directory node[:appdynamics][:controller][:dir] do
  owner "appdynamics"
  group "appdynamics"
  mode "0755"
  recursive true
end


# Should get version numbers in here 
remote_file "/usr/local/src/controller_64bit_linux_v#{node[:appdynamics][:controller][:version]}.sh" do
  source node[:appdynamics][:controller][:install][:url]
  checksum node[:appdynamics][:controller][:install][:sha]
  mode "0755"
end


template "/tmp/controllerinstaller.var" do
  source "controllerinstaller.var.erb"
  owner "appdynamics"
end
# TODO should be sharing this in a var with the remote file 
execute "install_appdynamics_controller"  do 
  
  command "/usr/local/src/controller_64bit_linux_v#{node[:appdynamics][:controller][:version]}.sh -q -varfile /tmp/controllerinstaller.var"
  not_if "test -f #{node[:appdynamics][:dir]}/bin/controller.sh"
  user "appdynamics"
  
end

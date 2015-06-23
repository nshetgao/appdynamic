#
# Cookbook Name:: appdynamics
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#Depends on angel_core which creates the jbrunner user
package "angel_core"


remote_directory "/usr/local/angel.com/appdynamics" do
  source "appdynamics" # this is the value that should be inferred from the path parameter
  files_owner "jbrunner"
  files_group "jbrunner"
  files_mode "0644"
end



#log directory for the machine agent of appdynamics

directory "/var/log/angel/appdynamics/machineagent" do
  owner "jbrunner"
  group "jbrunner"
  mode "0755"
  recursive true
end



#Create config directory, and log dir for machine agent because there is nothing in the files for a conf directory (git and empty directories is a long standing issue""


directory "/usr/local/angel.com/appdynamics/conf" do
  owner "jbrunner"
  group "jbrunner"  
end



#The configuration for appdynamics
template "/usr/local/angel.com/appdynamics/conf/controller-info.xml" do
  source "controller-info.xml.erb"
  owner "jbrunner"
  group "jbrunner"
  mode "0644"
end


#We're reuse the config for the machine agent
template "/usr/local/angel.com/appdynamics/machineagent/conf/controller-info.xml" do
  source "machine-controller-info.xml.erb"
  owner "jbrunner"
  group "jbrunner"
  mode "0644"
  
end
  

#parameterize the sh script used to run this machine agent because it doesn't always seem to honor the controller-info.xml/we were doing it wrong
template "/usr/local/angel.com/appdynamics/machineagent.sh" do
  source "machineagent.sh.erb"
  owner "jbrunner"
  group "jbrunner"
  mode "0755"
end


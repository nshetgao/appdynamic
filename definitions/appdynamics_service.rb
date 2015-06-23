
#We're essentialy defining a new resource
define :appdynamics_service do

  include_recipe "appdynamics"
  
  #The string passed in to the resource
  #Called svc because service is while not a reserved keyword
  #is a chef resource
  svc = params[:name]
  
  #Symbols are usually used in hashes.  Normally you make them with :str but in this case it's a variable
  #if this is confusing, look over http://www.randomhacks.net/articles/2007/01/20/13-ways-of-looking-at-a-ruby-symbol
  #and it will be slighlty less confusing
  svcKey = svc.intern

  jvm_config_dir =   "/usr/local/angel.com/services/#{svc}/server"  
  servicename = "angel-#{svc}"
  
 #Defining the service that we can restart if there has been a change in the configuraiton
  service servicename do
    supports :status => true, :restart => true
    #If we wanted this added to startup at boo I think that we could just turn on the following line
    #actions :enable
  end


  
 #We're patching this file onto the run.conf file in the next section if it hasn't been
  #The file itself just instructs run.conf to source a file if it exists.  It is the existence of that file
  #which turns on appdynamics, this file is the check to see if it does
  template "/tmp/appdynamics_loading.patch" do
    source "appdynamics_loading.patch.erb"
    owner "jbrunner"
    variables(:service=>svc)
  end
  

  jvm_opts_file = "/usr/local/angel.com/services/#{svc}/scripts/jvm_opts.conf"
  bash "patch_to_look_for_appdynamics_file_for_#{svc}" do   
    # Some older rpms have the run.conf owned by root, plus this will prevent others from fiddling here
    # so I haven't specified the user to be jbrunner
    code "cat /tmp/appdynamics_loading.patch >> #{jvm_opts_file};chown jbrunner #{jvm_opts_file}"
    not_if "grep -i appdynamics #{jvm_opts_file}"
  end
  
  templateName = "/usr/local/angel.com/appdynamics/conf/appdynamics-#{svc}.conf"

  
   #Put the file in place with the configuation
   template templateName do
    source "appdynamics.conf.erb"
    owner "jbrunner"
    #This seems redunant, but unless I'm pulling node parameters, I think I need to supply the variable map to the template
    #But chances are we coudl do figure out how to do away with this.
    variables(:service=>svc)
    mode "0644"
    notifies :restart, "service[#{servicename}]"

  end


  link "/usr/local/angel.com/services/#{svc}/scripts/appdynamics.conf" do
    to  templateName
    #Also put a guard in place to ensure that we've got the attribute turned on.  Note the {} which is a ruby closure
    #If you passed in a string it woudl do a bash test (like -f)
    
    #If this block was executed, restart the service.  Useful in QE/Dev/ possibly dangerous in Prod
    notifies :restart, "service[#{servicename}]"
  end


  end
  

  

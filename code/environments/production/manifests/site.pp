node default {
# Test message
  # notify { "Debug output on ${hostname} node.": }
 
  # include ntp, git
}
 

# node 'collector01.example.com' {
#   file { '/tmp/testing':
#     ensure=> directory
#   }
# }

# node 'node01.example.com', 'node02.example.com' {
# # Test message
#   notify { "Debug output on ${hostname} node.": }
 
#   include ntp, git, docker, fig
# }

node /^collector..\.example\.com$/ {
  exec{'ppa:java':
    command => "sudo add-apt-repository ppa:webupd8team/java -y && sudo apt-get update && sudo apt-get install oracle-java8-installer -y",
    path => "/usr/bin/"
  }
  
  class { 'dynatraceappmon::role::collector':
    installer_file_url => 'https://files.dynatrace.com/downloads/OnPrem/dynaTrace/7.0/7.0.0.2469/dynatrace-collector-7.0.0.2469-linux-x86.jar',
    server_hostname => 'server'
  }
}


node 'server.example.com' {
  notify { "Debug output on ${hostname} node.": }
 
  exec{'ppa_java':
    command => "sudo add-apt-repository ppa:webupd8team/java -y && sudo apt-get update && sudo apt-get install oracle-java8-installer -y",
    path => "/usr/bin/",
    before => [Class['dynatraceappmon::role::server'],Class['dynatraceappmon::role::memory_analysis_server']]
  }
  class { 'dynatraceappmon::role::server':
    installer_file_url => 'https://files.dynatrace.com/downloads/OnPrem/dynaTrace/7.0/7.0.0.2469/dynatrace-full-7.0.0.2469-linux-x86-64.jar',
    
  }
  class { 'dynatraceappmon::role::memory_analysis_server':
    installer_file_url => 'https://files.dynatrace.com/downloads/OnPrem/dynaTrace/7.0/7.0.0.2469/dynatrace-analysisserver-7.0.0.2469-linux-x86.jar',
    
  }
}

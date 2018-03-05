node default {
# Test message
  notify { "Debug output on ${hostname} node.": }
 
  include ntp, git
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
  
  class { 'java' :
    package => 'java-1.8.0-openjdk-devel',
  }
  class { 'dynatraceappmon::role::collector':
    installer_file_url => 'https://files.dynatrace.com/downloads/OnPrem/dynaTrace/7.0/7.0.0.2469/dynatrace-collector-7.0.0.2469-linux-x86.jar'
  }
}


node /^server..\.example\.com$/ {
  class { 'java' :
    package => 'java-1.8.0-openjdk-devel',
  }
  class { 'dynatraceappmon::role::server':
    installer_file_url => 'https://files.dynatrace.com/downloads/OnPrem/dynaTrace/7.0/7.0.0.2469/dynatrace-full-7.0.0.2469-linux-x86-64.jar'
  }
  class { 'dynatraceappmon::role::memory_analysis_server':
    installer_file_url => 'https://files.dynatrace.com/downloads/OnPrem/dynaTrace/7.0/7.0.0.2469/dynatrace-analysisserver-7.0.0.2469-linux-x86.jar'
  }
}

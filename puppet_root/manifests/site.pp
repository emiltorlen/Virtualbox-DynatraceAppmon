node default {
# Test message
  notify { "Debug output on ${hostname} node.": }
 
  include ntp, git
}
 
node 'node01.example.com', 'node02.example.com' {
# Test message
  notify { "Debug output on ${hostname} node.": }
 
  include ntp, git, docker, fig
}

node /^collector..\.example\.com$/ {
  include dynatraceappmon
  include java
  class { 'java':
    distribution => 'jre',
  }

  class { 'dynatraceappmon::role::server':
    installer_file_url => 'https://files.dynatrace.com/downloads/OnPrem/dynaTrace/7.0/7.0.0.2469/dynatrace-full-7.0.0.2469-linux-x86-64.jar'
  }
}

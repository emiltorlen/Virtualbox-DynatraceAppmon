# Class: fig
#
# This module install Fig (http://www.fig.sh)
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage: include fig
#
class fig () {
  Exec {
    path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'] }

  exec { 'download-fig':
    command => 'curl -L https://github.com/docker/fig/releases/download/1.0.1/fig-`uname -s`-`uname -m` > /tmp/fig',
    user    => root,
    onlyif  => 'test ! -f /usr/local/bin/fig'
  } ->
  exec { 'move-fig':
    command => 'mv /tmp/fig /usr/local/bin',
    user    => root,
    onlyif  => 'test ! -f /usr/local/bin/fig'
  } ->
  file { '/usr/local/bin/fig':
    path  => '/usr/local/bin/fig',
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }
}

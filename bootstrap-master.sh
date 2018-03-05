#!/bin/sh
 
# Run on VM to bootstrap Puppet Master server
 
if ps aux | grep "puppet master" | grep -v grep 2> /dev/null
then
    echo "Puppet Master is already installed. Exiting..."
else
    # Install Puppet Master
    # wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb && \
    sudo dpkg -i puppetlabs-release-pc1-trusty.deb && \
    sudo apt-get update -yq && sudo apt-get upgrade -yq && \
    sudo apt-get install -yq puppetserver
    # sudo chmod -R 0777 /opt/puppetlabs/
    sudo chmod -R o-w /opt/puppetlabs/

    # add link to bin
    sudo ln -s /opt/puppetlabs/server/bin/puppetserver /bin/puppetserver
    sudo ln -s /opt/puppetlabs/server/bin/puppetserver /usr/bin/puppetserver

    sudo ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet
    sudo ln -s /opt/puppetlabs/puppet/bin/puppet /bin/puppet

      # Autosigning
    sudo ln -s /vagrant/autosign.conf /etc/puppetlabs/puppet/autosign.conf
 
    # symlink manifest from Vagrant synced folder location
    mv /etc/puppetlabs/code /etc/puppetlabs/code_bk
    ln -s /vagrant/code /etc/puppetlabs/code
 
    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.5    puppet.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.10   collector02.example.com  collector02" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.20   server.example.com  server" | sudo tee --append /etc/hosts 2> /dev/null
    echo "192.168.32.21   collector01.example.com  collector" | sudo tee --append /etc/hosts 2> /dev/null && \
    # Add optional alternate DNS names to /etc/puppet/puppet.conf
    sudo sed -i 's/.*\[main\].*/&\ndns_alt_names = puppet,puppet.example.com/' /etc/puppet/puppet.conf
 
    # Install some initial puppet modules on Puppet Master server
    sudo puppet module install puppetlabs-ntp
    sudo puppet module install garethr-docker
    sudo puppet module install puppetlabs-git
    sudo puppet module install puppetlabs-vcsrepo
    sudo puppet module install garystafford-fig
    # Required for dynatrace
    sudo puppet module install puppetlabs-stdlib
    sudo puppet module install puppetlabs-apache
    sudo puppet module install puppetlabs-java
    sudo puppet module install puppetlabs-ruby
    sudo puppet module install maestrodev-wget
    sudo puppet module install AlexCline-dirtree



    sudo service puppetserver start
fi

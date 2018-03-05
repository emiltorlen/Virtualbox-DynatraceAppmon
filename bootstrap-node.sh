#!/bin/sh
 
# Run on VM to bootstrap Puppet Agent nodes
# http://blog.kloudless.com/2013/07/01/automating-development-environments-with-vagrant-and-puppet/
 
# if ps aux | grep "puppet agent" | grep -v grep 2> /dev/null

if puppet --version | grep -E '3.4.3|such' &> /dev/null
then
    echo "Old Puppet Agent is already installed. Removing... && installing"
    sudo rm -rf /bin/puppet
    sudo rm -rf /usr/bin/puppet
    sudo rm -rf /usr/bin/X11/puppet
    sudo rm -rf /usr/share/puppet
    sudo rm -rf /usr/share/man/man8/puppet.8.gz

    echo "Installing Agent"
    cd /tmp/ && wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
    sudo dpkg -i puppetlabs-release-pc1-trusty.deb
    sudo apt-get update -yq
    sudo apt-get install -yq puppet-agent
fi
 
if cat /etc/crontab | grep puppet 2> /dev/null
then
    echo "Puppet Agent is already configured. Exiting..."
else
    sudo apt-get update -yq && sudo apt-get upgrade -yq
    sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
    # sudo puppet resource cron puppet-agent ensure=present user=root minute=30 \
    #     command='/usr/bin/puppet agent --onetime --no-daemonize --splay'
 
    # sudo puppet resource service puppet ensure=running enable=true
 
    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.5    puppet.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.10   node01.example.com  node01" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.20   server.example.com  server" | sudo tee --append /etc/hosts 2> /dev/null
    echo "192.168.32.21   collector01.example.com  collector" | sudo tee --append /etc/hosts 2> /dev/null && \
 
    # Add agent section to /etc/puppet/puppet.conf
    echo "" && echo "[agent]\nserver=puppet" | sudo tee --append /etc/puppet/puppet.conf 2> /dev/null
    # symbolic links
    sudo ln -s /opt/puppetlabs/bin/puppet /bin/puppet
    sudo ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet
    sudo puppet agent --enable
    rm -r /home/vagrant/.puppet/ssl && puppet agent -t
fi
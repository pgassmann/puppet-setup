#!/bin/bash
set -x

dir="$(dirname $(readlink -f $0))"
cd $dir

# git pull && git submodule update --init
if [ ! -f Gemfile.lock ]; then
#first run
  apt-get update
  apt-get install -y ruby ruby-dev make git
  gem install bundler
  bundle install --path=setup/bundle --binstubs=setup/bundlebin
fi

# get environment from current git branch
environment=$(git symbolic-ref --short HEAD)

# ssh wrapper to use custom sshkey for git
export GIT_SSH="${dir}/setup/git_ssh"

#fix permissions of ssh private key
chmod 600 $dir/setup/.ssh/puppet_rsa

# deploy Puppetmodules and hieradata
# deploys from remote git repository!
setup/bundlebin/r10k deploy environment $environment

# Run Puppet
setup/bundlebin/puppet apply --modulepath=/etc/puppet/environments/$environment/modules --hiera_config=hiera.yaml --environment $environment site.pp $@

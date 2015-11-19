#!/bin/bash
set -x

dir="$(dirname $(readlink -f $0))"
cd $dir

# first run, no bundle commmand
if ! hash bundle 2>/dev/null;  then
  apt-get update
  apt-get install -y ruby ruby-dev make git
  gem install bundler --no-ri --no-rdoc
fi

# Install gems from Gemfile or Gemfile.lock if checked in
bundle install --path=.bundle --binstubs=bin

# get environment from current git branch
environment=$(git symbolic-ref --short HEAD)

# create environment
mkdir -p /etc/puppet/environments/$environment

#deploy hieradata
rsync -av --delete hieradata /etc/puppet/environments/$environment

# install modules with librarian-puppet
./bin/librarian-puppet install --path=/etc/puppet/environments/$environment/modules --verbose

# Run Puppet
./bin/puppet apply --modulepath=/etc/puppet/environments/$environment/modules --hiera_config=hiera.yaml --environment $environment site.pp $@

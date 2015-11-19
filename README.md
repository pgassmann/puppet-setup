Masterless Puppet all-in-one
======================================

Why?
----
 * Small flexible system to puppetize servers for example in a home setup environment.
 * Use librarian-puppet to list puppetmodules, but without a Puppetmaster.
 * All the configuration and scripts in one git repository.

What
----
 * One single repository with
   * hieradata
   * Puppetfile for librarian-puppet
   * Gemfile for tool installation with bundler
   * Setup mechanism
 * Supports dynamic environments from git branches
 * Requires no Puppetmaster
 * All sources can be git repositories, so you can mirror them on a git server and have full control over your sources
 * Installs puppet using bundler and Gemfile to a separate path from system gems

Prerequisites
-------------
 * VM with Ubuntu 14.04 Server and hostname configured to match hieradata.
 * Git to clone the repo

For this PoC set the fqdn to 'owncloud.example.com' or assign the role through the fact _custom_role_.

Bootstrap
---------
Run the following commands to setup your server.

    apt-get install git -y
    git clone https://github.com/pgassmann/r10k-masterless-poc.git puppet-setup
    cd puppet-setup
    ./setup.sh
    # or
    FACTER_custom_role=owncloud ./setup.sh

How it works
------------

###First run:

 - Install sytem packages ruby, ruby-dev and make
 - Install bundler as gem
 - Install puppet and dependencies with bundle to a local path

### populate environment and puppet apply
 - get environment from current git branch
 - rsync hieradata to environment
 - librarian-puppet deploys the modules to the environment using the Puppetfile
 - puppet apply with hieradata and modules in environment

Issues and Ideas
----------------

 * The setup files, including the hieradata are deployed on every node you install with this mechanism, files are all world-readable because git only knows 644 or 755 as permission.
 * Use this repository to setup the puppet master and then attach the nodes to it. You still have the fallback to apply the config on any node without puppetmaster or immediately redeploy the puppetmaster

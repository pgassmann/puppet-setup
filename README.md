Masterless Puppet with r10k all-in-one
======================================

Why?
----
 * Small flexible system to puppetize servers for example in a home setup environment.
 * Use r10k to list puppetmodules, but without a Puppetmaster.
 * All the configuration and scripts in one git repository.

What
----
 * One single repository with
   * hieradata
   * Puppetfile for r10k
   * Gemfile for tool installation with bundler
   * r10k configuration
   * Setup mechanisms
   * ssh deploy key included
 * Supports dynamic environments from git branches
 * Requires no Puppetmaster
 * All sources can be git repositories, so you can mirror them on a git server and have full control over your sources
 * Installs puppet using bundler and Gemfile to a separate path from system gems
 * r10k deploy environment with custom ssh key (Deploy key with read-only on the git repo)

Prerequisites
-------------
 * VM with Ubuntu 14.04 Server and hostname configured to match hieradata.

For this PoC set the fqdn to 'owncloud.example.com'

Bootstrap
---------
Run the following commands to setup your server.

    apt-get install git -y
    git clone https://github.com/pgassmann/r10k-masterless-poc.git
    cd r10k-masterless-poc
    ./setup.sh

How it works
------------

###First run:

 - Install sytem packages ruby, ruby-dev and make
 - Install bundler as gem
 - Install puppet and dependencies with bundle to a local path

### r10k and puppet apply
 - get environment from current git branch
 - r10k deploys the environment (again from remote git, using ssh deploy key!)
   - To make this work, you need a ssh wrapper that git will use:
   - export GIT_SSH with ssh wrapper to use custom sshkey for git
 - puppet apply with hieradata and modules from r10k

Issues and Ideas
----------------

 * The setup files, including the sshkey is deployed to the puppet environment by r10k, files are all world-readable because git only knows 644 or 755 as permission.
 * repository is checked out twice on the system.
 * Possible improvement: use local git repository as source for r10k
 * Deployment process with r10k is complicated.
 * You could also just use r10k puppetfile install and then use this as source for puppet apply.

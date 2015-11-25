# site.pp
# resource defaults and hiera_include

Package { allow_virtual => true, }
Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }

# set global variable $role from hiera or from fact custom_role
# roles/$::role is also set as a level in hiera.yaml
# FACTER_custom_role=foo ./setup.sh
$role = hiera('role', $::custom_role)

node default {
  hiera_include('classes', [])
  hiera_resources('additional_resources', {})
}

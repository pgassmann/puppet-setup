# site.pp
# resource defaults and hiera_include

Package { allow_virtual => true, }
Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }

node default {
  hiera_include('classes')
}

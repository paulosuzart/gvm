# == Define: gvm::manage_package
#
# Manages GVM packages. Installing or removing them.

# === Parameters
#
#
# [*is_version*]
#
# Informe if version should be set as default by gvm
# 
# [*version*]
# The version of package itself
# 
# [*name*]
# Name of the given package being managed. If not present, title is used.
#

define gvm::package (
  $package_name =  $name,
  $version,
  $is_default   = false,
  $ensure       = present,
  $timeout      = 0 # disabled by default instead of 300 seconds defined by Puppet
) {

  $gvm_init = "source $gvm::user_home/.gvm/bin/gvm-init.sh"

  $gvm_operation_unless = $ensure ? {
    present => "test -d $gvm::user_home/.gvm/$package_name/$version",
    absent  => "[ ! -d $gvm::user_home/.gvm/$package_name/$version ]",
  }

  $gvm_operation = $ensure ? {
    present => "install",
    absent  => "rm"
  }

  exec { "gvm $gvm_operation $package_name $version" :
    environment => $gvm::base_env,
    command      => "bash -c '$gvm_init && gvm $gvm_operation $package_name $version'",
    unless       => $gvm_operation_unless,
    user         => $owner,
    require      => Class['gvm'],
    path         => "/usr/bin:/usr/sbin:/bin",
    logoutput    => true,
    timeout      => $timeout
  }
  
  if $ensure == present and $is_default {
    exec {"gvm default $package_name $version" :
      environment => $gvm::base_env,
      command     => "bash -c '$gvm_init && gvm default $package_name $version'",
      user        => $owner,
      path        => '/usr/bin:/usr/sbin:/bin',
      logoutput   => true,
      require     => Exec["gvm install $package_name $version"],
      unless      => "test \"$version\" = \$(find $user_home/.gvm/$package_name -type l -printf '%p -> %l\\n'| awk '{print \$3}' | awk -F'/' '{print \$NF}')",
      timeout      => $timeout
    }
  }
    
}

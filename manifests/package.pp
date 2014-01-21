# == Define: gvm::gvm_package
#
# Setups GVM packages and set their

# === Parameters
#
# [*owner*]
# The user that owns package. This is use to infer where to install GVM: /home/$owner/.gvm
#
# [*is_default*]
#
# Makes the given package as gvm default
# 
# [*version*]
# The version of package itself

define gvm::package ($version, $is_default = false, $owner) {

  $user_home = "/home/$owner"
  $gvm_init = "source $user_home/.gvm/bin/gvm-init.sh"

  exec { $name :
    environment  => "HOME=$user_home",
    command      => "bash -c '$gvm_init && gvm install $name $version'",
    unless       => "test -d $user_home/.gvm/$name/$version",
    user         => $owner,
    require      => Exec['GVM'],
    path         => "/usr/bin:/usr/sbin:/bin",
    logoutput    => true
  }
  
  if $is_default {
    exec {"gvm default $name" :
      environment => "HOME=$user_home",
      command     => "bash -c '$gvm_init && gvm default $name $version'",
      user        => $owner,
      path        => '/usr/bin:/usr/sbin:/bin',
      logoutput   => true,
      unless      => "test \"$version\" = \$(find $user_home/.gvm/$name -type l -printf '%p -> %l\\n'| awk '{print \$3}' | awk -F'/' '{print \$NF}')"
    }
  }
    
}


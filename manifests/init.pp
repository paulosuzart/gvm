# == Define: gvm
#
# Setup GVM

# === Parameters
#
# [*owner*]
# The user that owns the package. If homedir is not specified, this is used to infer where to install GVM:
# /home/$owner/.gvm or /root if user is root
#
# [*group*]
# The group that owns the package.  Defaults to be the same as $owner, if unspecified.
#
# [*homedir*]
# The owner's home directory.  This can be omitted if the home directory is /root or /home/$owner

class gvm (
    $owner = 'root',
    $group = '',
    $homedir = '',
) {

    $user_group = $group ? {
      '' => $owner,
      default => $group
    }

    $user_home = $homedir ? {
      '' => $owner ? {
        'root' =>  '/root',
        default => "/home/$owner"
      },
      default => $homedir
    }

    wget::fetch {'http://get.gvmtool.net':,
      destination => "/tmp/gvm-install.sh",
      verbose     => true,
      execuser    => $owner,
      user        => $owner,
    } ~>
    exec { 'GVM' :
      user        => $owner,
      environment => "HOME=$user_home",
      path        => "/usr/bin:/usr/sbin:/bin",
      command     => "bash gvm-install.sh",
      cwd         => '/tmp',
      logoutput   => true,
      unless      => 'test -e $HOME/.gvm',
      require     => Package['unzip'],
    } ~>
    file {"$user_home/.gvm/etc/config" :
      ensure => file,
      owner  => $owner,
      group  => $user_group,
      source => "puppet:///modules/gvm/gvm_config"
    }
}

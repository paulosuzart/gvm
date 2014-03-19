# == Define: gvm
#
# Setup GVM 

# === Parameters
#
# [*owner*]
# The user that owns package. This is use to infer where to install GVM: /home/$owner/.gvm or /root 
# if user is root

class gvm ($owner = 'root') {

    $user_home = $owner ? {
      'root' =>  '/root',
      default => "/home/$owner"      
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
      group  => $owner,
      source => "puppet:///modules/gvm/gvm_config"
    }
}

paulosuzart/gvm
---------------

Module can be use to install GVM and also install required packages;

Usage
-----

````puppet
    class { 'gvm' :
      owner => $user_name,
    }
````

   - `owner` is the user name that will own the installation. From it the home of the user is assumed to be /home/$owner.

To install packages simply do:

````puppet
    gvm::package { 'grails' :
      version   => '2.1.5',
      is_defult => true,
      owner     => $username
    }
````

   - `version` will make `gvm::package` to install the given version of the package
   - `is_default` will make this package as default if you want to install many versions
   - `owner` same as in `class gvm`

Limitations
-----------
Tested and mostly built to run with Ubuntu/Debian. Futher versions should add suport for **Mac** and other distributions.


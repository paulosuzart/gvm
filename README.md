paulosuzart/gvm
---------------

Module can be use to install GVM and manage its available packages;

Usage
-----

````puppet
    class { 'gvm' :
      owner => 'someuser',
    }
````

   - `owner` is the user name that will own the installation. From it the home of the user is assumed to be `/home/$owner`, or `/root` if the provided user is `root`. Defaults to `root`.

To install packages simply do:

````puppet
  gvm::package { 'grails':
    version    => '2.1.5',
    is_default => true,
    ensure     => present #default
  }
````

   - `version` will make `gvm::package` to install the given version of the package
   - `is_default` will make this package as default if you want to install many versions
   
To remove packages use the extra argument `package_name` (defaults to `name`) like this:

````puppet
  gvm::package { 'remove grails 2.0.1':
    package_name => 'grails',
    version   => '2.0.1',
    ensure    => absent,
  }
````

Limitations
-----------
Tested and mostly built to run with Ubuntu/Debian. Futher versions should add suport for **Mac** and other distributions.

Release Notes
-------------
Notes for release 1.0.1

  - Timeout parameter added to gvm::package.
  - User fix. GVM installation condition changed. Ensuer file added.
  - Fixed wrong HOME environment variable while installing a package.

With special thanks to [Athlan](https://github.com/athlan) contribution.



Notes for release 1.0.0 

  - Added support for `root` user if you want to use this package in your server.
  - Added ability to remove gvm packages


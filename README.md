# puppet-ispconfig

#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Usage](#usage)
4. [Reference](#reference)
5. [Limitations](#limitations)

## Overview

Debian 8 / ISPConfig 3 / Apache / MariaDB / PHP7 :

## Required dependencies

* Puppet module : puppetlabs/stdlib >= 4.5.0 < 5.0.0
* Puppet module : puppetlabs/apt >= 2.2.1
* Puppet module : puppetlabs/apt >= 2.2.2
* Puppet module : puppetlabs/ntp >= 4.1.2
* Puppet module : puppetlabs/git >= 0.4.0
* Puppet module : puppetlabs/mysql 3.6.2
* Puppet module : puppetlabs/apache >=1.9.0
* Puppet module : https://github.com/loispuig/puppet-dotdeb.git
* Puppet module : https://github.com/loispuig/puppet-hostname.git
* Puppet module : https://github.com/loispuig/puppet-locales.git
* Puppet module : https://github.com/loispuig/puppet-timezone.git
* Puppet module : https://github.com/loispuig/puppet-pagespeed.git
* Puppet module : https://github.com/loispuig/puppet-php7.git
* Puppet module : https://github.com/loispuig/puppet-phpmyadmin.git

## Usage

Insert the following line into your puppet manifest.
```
include ispconfig
```

## Reference

## Limitations

Tested on Debian 8 using Puppet 4
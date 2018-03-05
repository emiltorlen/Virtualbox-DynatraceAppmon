# fig #

Puppet module for downloading and installing Fig v1.0.1 (http://www.fig.sh).

## Support

This module is currently tested on:

* Ubuntu 12.04
* Ubuntu 14.04
* Ubuntu 14.10
* CentOS 6.6

It may work on other distros...

## Usage

The module includes a single class:

```puppet
include 'fig'
```

```puppet
class { 'fig': }
```

## Test Install
`which fig; fig --version`

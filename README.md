# puppet-stns

[![Build Status](https://img.shields.io/travis/STNS/puppet-stns/master.svg?style=flat-square)](https://travis-ci.org/STNS/puppet-stns)
[![Puppet Forge](https://img.shields.io/puppetforge/v/hfm/stns.svg?style=flat-square)](https://forge.puppetlabs.com/hfm/stns)

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with stns](#setup)
  - [Setup requirements](#setup-requirements)
  - [Beginning with stns](#beginning-with-stns)
1. [Usage - Configuration options and additional functionality](#usage)
  - [Configuring stns::server](#configuring-stnsserver)
  - [Configuring stns::client](#configuring-stnsclient)
  - [Configuring modules from Hiera](#configuring-modules-from-hiera)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
  - [Public Classes](#public-classes)
  - [Private Classes](#private-classes)
  - [Defined Types](#defined-types)
  - [Parameters](#parameters)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
  - [Running tests](#running-tests)
  - [Testing quickstart](#testing-quickstart)
  - [Smoke tests](#smoke-tests)

## Description

The STNS module handles installing, configuring, and running [STNS](https://github.com/STNS/STNS) and [libnss_stns](https://github.com/STNS/libnss_stns).

## Setup

### Setup Requirements

The STNS module requires the following puppet modules:

- [puppetlabs-stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib): version 4.0 or newer.
- [puppetlabs-apt](https://forge.puppetlabs.com/puppetlabs/apt): version 2.0 or newer (only Debian-based distributions).

### Beginning with STNS

To install the STNS server with default parameters, declare the `stns::server` class.

```puppet
include ::stns::server
```

To install the STNS client (libnss\_stns and libpam\_stns) with default parameters, declare the `stns::client` class.

```puppet
include ::stns::client
```

## Usage

### Configuring stns::server

```puppet
class { '::stns::server':
  port     => 1104,
  user     => 'sample',
  password => 's@mp1e',
}

# Configures users and groups
stns::server::users {
  'foo':
    id         => 1001,
    group_id   => 1001,
    directory  => '/home/foo',
    shell      => '/bin/bash';

  'bar':
    id         => 1002,
    group_id   => 1001,
    directory  => '/home/bar',
    shell      => '/bin/bash';
}

stns::server::groups { 'sample':
  id    => 1001,
  users => [
    'foo',
    'bar',
  ],
}
```

### Configuring stns::client

```puppet
class { '::stns::client':
  api_end_point      => [
    'http://stns1.example.jp:1104',
    'http://stns2.example.jp:1104',
  ],
  user               => 'sample',
  password           => 's@mp1e',
  wrapper_path       => '/usr/local/bin/stns-query-wrapper',
  chain_ssh_wrapper  => '/usr/libexec/openssh/ssh-ldap-wrapper',
  ssl_verify         => true,
  handle_nsswitch    => true,
  handle_sshd_config => true,
}
```

### Configuring modules from Hiera

```yaml
---
stns::server::port: 1104
stns::server::user: sample
stns::server::password: s@mp1e

stns::client::api_end_point:
  - 'http://stns1.example.jp:1104'
  - 'http://stns2.example.jp:1104'
stns::client::user: sample
stns::client::password: s@mp1e
stns::client::wrapper_path: '/usr/local/bin/stns-query-wrapper'
stns::client::chain_ssh_wrapper: null
stns::client::ssl_verify: true
stns::client::handle_nsswitch: true
stns::client::handle_sshd_config: true
```

## Reference

### Public Classes

- [`stns::server`](#stnsserver): Installs and configures STNS.
- [`stns::client`](#stnsclient): Installs and configures libnss\_stns and libpam\_stns.

### Private Classes

- `stns::repo`: Setup STNS repository.
- `stns::server::install`: Installs STNS package.
- `stns::server::config`: Configures STNS.
- `stns::server::server`: Manages service.
- `stns::client::install`: Installs packages for libnss\_stns and libpam\_stns.
- `stns::client::config`: Configures

### Defined Types

- `stns::server::users`: Specifies a STNS users configuration file.
- `stns::server::groups`: Specifies a STNS groups configuration file.

### Parameters

#### Class: `stns::server`

- `port`: Specifies a listen port listen. Valid options: a number of a port number. Default: 1104.
- `user`: Specifies a user for authentication. Valid options: a string containing a valid username. Default: 'undef'.
- `password`: Specifies a password for authentication. Valid options: a string containing a valid password. Default: 'undef'.

#### Class: `stns::client`

- `api_end_point`: Valid options: Default: 'http://localhost:1104'.
- `user`: Specifies a user for authentication. Valid options: a string containing a valid username. Default: 'undef'.
- `password`: Specifies a password for authentication. Valid options: a string containing a valid password. Default: 'undef'.
- `wrapper_path`: Valid options: absolute path. Default: '/usr/local/bin/stns-query-wrapper'.
- `chain_ssh_wrapper`: Default: 'undef'.
- `ssl_verify`: Enables SSL verification. Valid options: a boolean. Default: true.
- `handle_nsswitch`: Configure nsswitch.conf to use STNS. Valid options: a boolean. Default: false.
- `handle_sshd_config`: Configure sshd\_config to use STNS. Valid options: a boolean. Default: false.

#### Defined Types: `stns::server::users`

- `id`: Specifies the user ID. Valid options: a number type. Default: undef.
- `group_id`: Specifies the user's primary group. Valid options: a number type. Default: undef.
- `directory`: Specifies the home directory of the user. Valid options: a string containing a valid path. Default: `/home/<resource title>`.
- `shell`: Specifies the user's login shell. Valid options: a string containing a valid path. Default: `/bin/bash`.
- `keys`: Specify user attributes in an array of key = value pairs. Valid options: a string containing a valid key = value pairs. Default: undef.
- `link_users`: Valid options: a string containing a valid password. Default: undef.

#### Defined Types: `stns::server::groups`

- `id`: Specifies the group ID. Valid options: a number type. Default: undef.
- `users`: Specifies the members of the group. Valid options: a string containing a valid password. Default: undef.

##### Parameters

## Limitations

This module has been tested on:

- RedHat Enterprise Linux 5, 6, 7
- CentOS 5, 6, 7
- Scientific Linux 5, 6, 7
- Debian 7, 8
- Ubuntu 12.04, 14.04, 16.04

## Development

### Running tests

The STNS puppet module contains tests for both [rspec-puppet](http://rspec-puppet.com/) (unit tests) and [beaker-rspec](https://github.com/puppetlabs/beaker-rspec) (acceptance tests) to verify functionality. For detailed information on using these tools, please see their respective documentation.

#### Testing quickstart

- Unit tests:

```console
$ bundle install
$ bundle exec rake
```

- Acceptance tests:

```console
# Set your DOCKER_HOST variable
$ eval "$(docker-machine env default)"

# List available beaker nodesets
$ bundle exec rake beaker_nodes
centos6
centos7
jessie
trusty

# Run beaker acceptance tests
$ BEAKER_set=centos7 bundle exec rake beaker
```

#### Smoke tests

You can run smoke tests using [Vagrant](https://www.vagrantup.com/):

```console
$ vagrant up <vm> --provision
```

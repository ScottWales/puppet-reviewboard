## \file    testing/vagrant.pp
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  \brief
#
#  Copyright 2014 Scott Wales
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

node default {
  include postgresql::server
  include postgresql::lib::python

  package {['memcached','python-memcached','python-ldap']:}

  reviewboard::site {'/var/www/reviewboard':
    require   => [
      Class['postgresql::server','postgresql::lib::python'],
      Package['memcached','python-memcached','python-ldap']
    ],
    dbpass    => 'testing',
    adminpass => 'testing',
  }
  #  reviewboard::site::ldap {'/var/www/reviewboard':
  #    uri    => 'test.example.com',
  #    basedn => 'dn=test,dn=example,dn=com',
  #  }

  # Disable the firewall
  service {'iptables':
    ensure => stopped,
  }
}

## \file    manifests/site.pp
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

# Set up a reviewboard site

define reviewboard::site (
  $path       = '/var/www/reviewboard',
  $url        = '/reviewboard/',
  $dbtype     = 'postgresql',
  $dbname     = 'reviewboard',
  $dbuser     = 'reviewboard',
  $dbpass     = 'UNSAFE',
  $admin      = 'admin',
  $adminpass  = 'UNSAFE',
  $adminemail = 'apache',
  $cache      = 'memcached',
  $cacheinfo  = 'localhost:11211',
  $wwwuser    = 'apache',
) {

  if $dbpass == 'UNSAFE' {
    err('Postges DB password not set')
  }
  if $adminpass == 'UNSAFE' {
    err('Admin password not set')
  }

  # Create the database
  if $dbtype == 'postgresql' {
    postgresql::server::db {$dbname:
      user     => $dbuser,
      password => postgresql_password($dbuser,$dbpass),
      before   => Exec["rb-site install ${name}"],
    }
  } else {
    err("dbtype ${dbtype} not implemented")
  }

  $args = [
    '--noinput',
    "--domain-name ${::fqdn}",
    "--site-root ${url}",
    "--db-type ${dbtype}",
    "--db-name ${dbname}",
    "--db-user ${dbuser}",
    "--db-pass ${dbpass}",
    "--cache-type ${cache}",
    "--cache-info ${cacheinfo}",
    '--web-server-type apache',
    '--python-loader wsgi',
    "--admin-user ${admin}",
    "--admin-pass ${adminpass}",
    "--admin-email ${adminemail}",
  ]

  $argstr = join($args, ' ')

  exec {"rb-site install ${name}":
    require => Class[reviewboard::package],
    command => "rb-site install ${path} ${argstr}",
    path    => '/usr/bin',
    creates => $path,
  }

  file {'/etc/httpd/conf.d/reviewboard.conf':
    ensure  => link,
    require => Exec["rb-site install ${name}"],
    target  => "${path}/conf/apache-wsgi.conf",
    notify  => Service[httpd]
  }

  service {'httpd':
    ensure => running,
  }
}

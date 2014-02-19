#  \file    manifests/site.pp
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
  $vhost      = $::fqdn,
  $location   = '/reviewboard/',
  $dbtype     = 'postgresql',
  $dbname     = 'reviewboard',
  $dbhost     = 'localhost',
  $dbuser     = 'reviewboard',
  $dbpass     = undef,
  $admin      = 'admin',
  $adminpass  = undef,
  $adminemail = 'apache',
  $cache      = 'memcached',
  $cacheinfo  = 'localhost:11211',
  $wwwuser    = 'apache',
) {
  include reviewboard

  if $dbpass == undef {
    err('Postges DB password not set')
  }
  if $adminpass == undef {
    err('Admin password not set')
  }

  # Create the database
  if $dbtype == 'postgresql' {
    reviewboard::provider::db::puppetlabspostgresql {$name:
      dbuser => $dbuser,
      dbpass => $dbpass,
      dbname => $dbname,
      dbhost => $dbhost,
    }
  } else {
    err("dbtype ${dbtype} not implemented")
  }

  $args = [
    '--noinput',
    "--domain-name ${vhost}",
    "--site-root ${location}",
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

  # Directories written by the web server
  file {["${path}/data","${path}/htdocs/media/ext"]:
    ensure  => directory,
    owner   => $wwwuser,
    recurse => true,
  }

  # Set up the web server
  reviewboard::provider::web::simple {$name:
    vhost       => $vhost,
    location    => $location,
    reviewboard => $path,
    require     => [
      Exec["rb-site install ${name}"],
      File["${path}/data","${path}/htdocs/media/ext"],
    ],
  }

}

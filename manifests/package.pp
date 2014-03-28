## \file    manifests/package.pp
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

class reviewboard::package {

  # Install Reviewboard 2 as that supports custom extensions
  $version = '2.0beta3'

  package { 'python-pip':
    ensure => installed,
  }

  exec {'easy_install reviewboard':
    command => "easy_install http://downloads.reviewboard.org/releases/ReviewBoard/2.0/ReviewBoard-${version}-py2.6.egg",
    unless  => "pip freeze | grep 'ReviewBoard==${version}'",
    path    => ['/bin','/usr/bin' ],
    require => Package['python-pip'],
  }

}

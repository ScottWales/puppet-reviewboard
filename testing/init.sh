#!/bin/bash
## \file    testing/init.sh
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  
#  Copyright 2014 ARC Centre of Excellence for Climate Systems Science
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
#  

# Bootstrap puppet & install module pre-requisites

rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
yum install --assumeyes puppet git

gem install librarian-puppet

# We run librarian-puppet in the /etc/puppet directory as you can get errors
# running in a directory shared by vagrant 
# See https://github.com/rodjek/librarian-puppet/issues/57

ln -sf /vagrant/Modulefile /etc/puppet
ln -sf /vagrant/Puppetfile /etc/puppet
cd /etc/puppet && librarian-puppet install --verbose

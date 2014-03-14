## \file    manifests/traclink.pp
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

# Extension to automatically link reviews to Trac
# Requires trac to be installed first

class reviewboard::traclink {
  include reviewboard::package

  package {'traclink':
    source   => 'git+https://github.com/ScottWales/reviewboard-trac-link',
    provider => 'pip',
    require  => [Class[reviewboard::package],Package[trac]]
  }

  # Reload the web server after installing an extension
  Package['traclink'] ~> Reviewboard::Provider::Web<||>

}

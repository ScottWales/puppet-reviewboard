require 'spec_helper'

describe command('puppet apply /vagrant/testing/vagrant.pp --modulepath "/tmp/vagrant-puppet/modules:/etc/puppet/modules" --detailed-exitcodes') do
    it {should return_exit_status 0}
end

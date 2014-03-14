Puppet Reviewboard
==================

Manage an install of [Reviewboard](http://www.reviewboard.org)

To install include the package 'reviewboard' in your manifest

Optionally you can install the RBtool package for submitting reviews by
including 'reviewboard::rbtool'

Pre-Requisites
--------------

Puppet module pre-requisites are managed using
[librarian-puppet](https://github.com/rodjek/librarian-puppet)

Additionally the following optional prerequisites may be installed:

 * memcached & python-memcached for website caching
 * python-ldap for ldap authentication
 * python bindings for your database

Usage
-----

Create a reviewboard site based at '/var/www/reviewboard', available at ${::fqdn}/reviewboard:

    reviewboard::site {'/var/www/reviewboard':
        vhost    => "${::fqdn}",
        location => '/reviewboard'
    }

You can change how the sites are configured with the 'provider' arguments to the reviewboard class. 

**webprovider**:
  * *puppetlabs/apache*: Use puppetlabs/apache to create an Apache vhost
  * *simple*: Copy the apache config file generated by reviewboard & set up a basic Apache server
  * *none*: No web provisioning is done

**dbprovider**:
  * *puppetlabs/postgresql*: Use the puppetlabs/postgresql module to create database tables
  * *none*: No DB provisioning is done (note a database is required for the install to work)

The default settings are
    
    class reviewboard {
        webprovider => 'puppetlabs/apache',
        dbprovider  => 'puppetlabs/postgresql'
    }

To use a custom web provider set the 'webuser' parameter & subscribe the web
service to `reviewboard::provider::web<||>`:

    class reviewboard {
        webprovider => 'none',
        webuser     => 'apache',
    }
    Reviewboard::Provider::Web<||> ~> Service['apache']

You will then need to manually configure your web server, Reviewboard generates
an example Apache config file in ${site}/conf/apache-wsgi.conf.

Other Features
--------------

 * **RBTool**: Reviewboard command-line interface. To install:

        include reviewboard::rbtool

 * **LDAP Authentication**: Set up LDAP authentication via Puppet. To install:

        reviewboard::site::ldap {'/var/www/reviewboard':
            uri    => 'ldap://example.com',
            basedn => 'dn=example,dn=com',
        }

 * **Trac integration**: The 'traclink' Reviewboard plugin posts a notice on a Trac ticket whenever the 'Bug' field is set in a review. To install:

        package {trac: } # Make sure Trac is installed via Puppet
        include reviewboard::traclink

    There is also some setup required in your site's `trac.ini`:

        [ticket-custom]
        reviews = text
        reviews.format = wiki
        [interwiki]
        review = //reviewboard/r

Testing
-------

Integration tests make use of [serverspec](http://serverspec.org) to check the module is applied properly on a Vagrant VM.

To setup tests

    $ gem install bundler
    $ bundle install --path vendor/bundle

then to run the tests

    $ bundle exec rake

Use `vagrant destroy` to stop the test VM.


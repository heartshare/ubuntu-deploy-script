#! /bin/bash

#############################################################
#	Ubuntu Server Deploy Script (version 1.0)				#
#															#
#	004-rails.sh											#
#		Sets up ruby on rails and mod_passenger for apache2	#
#		hosting of rails applications						#
#															#
#															#
#		by William Hart (www.williamhart.info)				#
#		https://github.com/mecharius/ubuntu-deploy-script	#
#															#
#############################################################

# install required modules
apt-get install -y gcc checkinstall libxml2-dev libxslt-dev sqlite3 libsqlite3-dev libcurl4-openssl-dev libreadline6-dev libc6-dev libssl-dev libmysql++-dev make zlib1g0dev libicu-dev redis-server openssh-server python-dev python-pip libyaml-dev

# compile ruby v1.9.3-p194 from source
cd /opt/
curl -O http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
tar xzvf ruby-1.9.3-p194.tar.gz
cd ruby-1.9.3-p194
./configure
make
make install

# install ruby gems
cd /opt/ curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz
tar xzf rubygems-1.8.24.tgz
cd /opt/rubygems-1.8.24
ruby setup.rb
ln -s /usr/bin/gem1.8 /usr/bin/gem
gem update --system

# install mod_passenger
gem install passenger
passenger-install-apache2-module

# update the configuration file
echo "\n\n# mod_passenger tutorial" >> /etc/apache2/apache2.conf
echo "\nLoadModule passenger_module /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.15/ext/apache2/mod_passenger.so\n" >> /etc/apache2/apache2.conf
echo "PassengerRoot /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.15\n" >> /etc/apache2/apache2.conf
echo "PassengerRuby /usr/local/bin/ruby\n" >> /etc/apache2/apache2.conf

# restart apache
/etc/init.d/apache restart

# install fastthread 
gem install fastthread

# install rails
gem install rails --version 3.0.4 --no-rdoc -no-ri

### install database support
#mysql
apt-get install libmysqlclient16 libmysqlclient16-dev
gem install mysql

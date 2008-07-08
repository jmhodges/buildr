#!/bin/sh
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with this
# work for additional information regarding copyright ownership.  The ASF
# licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.
if [ -z `which ruby` ] ; then
  echo "You do not have Ruby 1.8.6 ..."
  # yum comes first since some people have apt-get installed in addition to yum.
  if [ `which yum` ] ; then
    echo "Installing Ruby using yum"
    sudo yum install ruby rubygems ruby-devel gcc
  elif [ `which apt-get` ] ; then
    echo "Installing Ruby using apt-get"
    # ruby package does not contain RDoc, IRB, etc; ruby-full is a meta-package.
    # build-essentials not installed by default in Ubuntu, required for C extensions.
    sudo apt-get install ruby-full ruby1.8-dev libopenssl-ruby build-essential 
    # RubyGems broken on Ubunutu, installing directly from source.
    echo "Installing RubyGems from RubyForge"
    wget http://rubyforge.org/frs/download.php/38646/rubygems-1.2.0.tgz 
    tar xzf rubygems-1.2.0.tgz
    cd rubygems-1.2.0
    sudo ruby setup.rb
    cd ..
    rm -rf rubygems-1.2.0
    # ruby is same as ruby1.8, we need gem that is same as gem1.8
    sudo ln -s /usr/bin/gem1.8 /usr/bin/gem
  else
    echo "Can only install Ruby 1.8.6 using apt-get or yum, and can't find either one"
    exit 1
  fi
  echo
fi

if [ -z $JAVA_HOME ] ; then
  echo "Please set JAVA_HOME before proceeding"
  exit 1
fi

if [ $(gem --version) \< '1.0.1' ] ; then
  echo "Upgrading to RubyGems 1.0.1"
  sudo gem update --system
  echo
fi

if [ `which buildr` ] ; then
  echo "Updating to the latest version of Buildr"
  sudo env JAVA_HOME=$JAVA_HOME gem update buildr
else
  echo "Installing the latest version of Buildr"
  sudo env JAVA_HOME=$JAVA_HOME gem install buildr
fi
echo

buildr --version

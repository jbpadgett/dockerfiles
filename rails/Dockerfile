FROM ubuntu:14.04
MAINTAINER JBPadgett "@jbpadgett"
ENV REFRESHED_AT 10-26-2015


# Repos Setup
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN sudo apt-get install -y apt-transport-https ca-certificates

# INSTALL DESIRED PACKAGES
RUN sudo apt-get update -qq && sudo apt-get install -y build-essential \
                                             curl \
                                             wget \
                                             inetutils-ping \
                                             git-core \
                                             git \
                                             zlib1g-dev \
                                             openssl \
                                             libssl-dev \
                                             libreadline-dev \
                                             libyaml-dev \
                                             libxml2-dev \
                                             libxslt-dev \
                                             libtool \
                                             libcurl4-openssl-dev \
                                             python-software-properties \
                                             software-properties-common \
                                             libffi-dev \
                                             bison \
                                             unzip \
                                             vim \
                                             libsqlite3-dev \
                                             sqlite3 \
                                             libpq-dev \
                                             postgresql-client \
                                             nodejs \
                                             supervisor


# Create rails & consul users to avoid root owning everything
RUN adduser --disabled-password --home=/rails --gecos "" rails
RUN adduser --disabled-password --home=/consul --gecos "" consul

# Install Consul Agent for service discovery/health checks
ADD https://dl.bintray.com/mitchellh/consul/0.4.0_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip
RUN mkdir -p /etc/consul.d/client && mkdir /var/consul
RUN chown consul:consul /var/consul
ADD ./consul/client/*.json /etc/consul.d/client/
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp

# Setup supervisord to manages processes
RUN mkdir -p /var/log/supervisor
COPY /docker/supervisor/rails.svc.conf /etc/supervisor/conf.d/rails.svc.conf

# Install Ruby from source
ADD http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.4.tar.gz /tmp/
RUN cd /tmp && \
      tar -xzf ruby-2.1.4.tar.gz && \
      cd ruby-2.1.4 && \
      ./configure && \
      make && \
      make install && \
      cd .. && \
      rm -rf ruby-2.1.4 && \
      rm -f ruby-2.1.4.tar.gz

# Install bundler
RUN gem install bundler --no-document

# Create rails app directory and set ownership to rails user
RUN mkdir -p /rails/myapp
#ADD . /myapp
RUN chown -R rails:rails /rails/myapp

### RAILS APP SECTION ###
# Gem installs
ADD Gemfile /rails/myapp/Gemfile
ADD Gemfile.lock /rails/myapp/Gemfile.lock
WORKDIR /rails/myapp 
RUN bundle install

# add default puma config
ADD config/puma.rb /rails/myapp/config/puma.rb

#Create VOLUME mount point for app code
VOLUME /rails/myapp

# Rails app env prep
EXPOSE 3000
WORKDIR /rails/myapp
# Puma is started via supervisord config
CMD ["/usr/bin/supervisord"]

FROM library/jenkins
MAINTAINER JBPadgett "@jbpadgett"
ENV REFRESHED_AT 10-25-2015

#REPOS SETUP	
USER root
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list

# INSTALL DESIRED PACKAGES
RUN apt-get update -qq && apt-get install -y build-essential \
                                             curl \
                                             wget \
                                             inetutils-ping \
                                             net-tools \
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
                                             byobu \
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


RUN rm -rf /var/lib/apt/lists/*

# Create users to avoid root owning everything
RUN adduser --disabled-password --home=/home/consul --gecos "" consul


# Install Consul Agent for service discovery/health checks
#ADD https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip /tmp/consul.zip
RUN wget https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip -O /tmp/consul.zip
RUN cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip
RUN mkdir -p /etc/consul.d/client && mkdir /var/consul
RUN chown consul:consul /var/consul
ADD ./consul/client/*.json /etc/consul.d/client/
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp

# Install Ruby from source
#ADD http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.4.tar.gz /tmp/
RUN wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.4.tar.gz -O /tmp/ruby-2.1.4.tar.gz
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

# Install SRC:CLR Console
RUN wget https://download.srcclr.com/console/srcclr-console-latest.zip -O /tmp/srcclr.zip
RUN cd /bin && unzip /tmp/srcclr.zip -d srcclr && rm /tmp/srcclr.zip

# Setup supervisord to manages processes
RUN mkdir -p /var/log/supervisor
COPY ci.svc.conf /etc/supervisor/conf.d/ci.svc.conf

# Setup scripts directory
COPY ./myscripts/* /var/jenkins_home/
RUN touch /var/log/copy_reference_file.log
RUN chown jenkins:jenkins /var/log/copy_reference_file.log

USER jenkins
#Automatically install plugins in Jenkins from text file
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

USER root
#Start multiple processes (consul,jenkins) with Supervisor
ENTRYPOINT ["/usr/bin/supervisord"]

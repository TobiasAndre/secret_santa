FROM ruby:2.5.1-slim

# Install our dependencies
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    build-essential libpq-dev imagemagick curl

# Install GNUPG
RUN apt-get install -y gnupg

# Install NodeJS v8
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn
      
# Define our patch
ENV INSTALL_PATH /nosso_amigo_secreto
# Creates our directory
RUN mkdir -p $INSTALL_PATH
# Defines our path as main directory
WORKDIR $INSTALL_PATH
# Copy our Gemfile to inside container
COPY Gemfile ./
# Defines the path to Gems
ENV BUNDLE_PATH /box
# Copy our code to inside container
COPY . .
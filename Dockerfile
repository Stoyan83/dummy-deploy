# Use an official Ruby runtime as a parent image
ARG RUBY_VERSION=3.1.2
FROM ruby:$RUBY_VERSION

# Install libvips for Active Storage preview support
RUN apt-get update && \
    apt-get install -y libvips && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Install necessary dependencies for Node.js installation
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Install Node.js and npm
RUN apt-get update && \
    apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Set production environment
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development"

# Rails app lives here
WORKDIR /rails

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Precompile assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE=524bc9ec4a9ece8b5c7df806c306ef2dae1d212036eecdabe4ace0cf07ffdeb1c3c60fd05770c24020ac43be2f373491d31be3503e8cc2a88d794f3d70cc322a bundle exec rake assets:precompile


# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

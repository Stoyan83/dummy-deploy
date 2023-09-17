# Use an official Ruby runtime as a parent image
ARG RUBY_VERSION=3.1.2
FROM ruby:$RUBY_VERSION

# Install libvips for Active Storage preview support
RUN apt-get update && \
    apt-get install -y libvips && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Install Node.js and npm (to install Yarn)
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

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

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]

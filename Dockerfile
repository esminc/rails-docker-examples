FROM ruby:2.6.2-slim

LABEL maintainer "Gentaro Terada <hibariya@gmail.com>"

# NOTE: Some packages such as postgresql-client expect that these directories exist for sure even though slim images do not have them
RUN bash -c "mkdir -p /usr/share/man/man{1..8}" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
         make gcc g++ libxml2-dev patch postgresql-client libpq-dev curl gnupg2 \
    && rm -rf /var/lib/apt/lists/* \
    && bash -c "rm -rf /usr/share/man/man{1..8}/*"

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler --no-document

RUN mkdir /app
WORKDIR /app
EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]

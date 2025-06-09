ARG RUBY_VERSION=4.0.1-slim
ARG BUNDLE_WITHOUT=development:test
ARG RUBY_GEM_SYSTEM_VERSION=4.0.7
ARG BUNDLE_WITHOUT="development test"
FROM ruby:${RUBY_VERSION}
LABEL org.opencontainers.image.source=https://github.com/manvil/camp-scrapper

RUN apt update -y && apt-get install -y build-essential ruby-dev libyaml-dev ruby-selenium-webdriver chromium-driver

RUN groupadd -g 1010 highvid
RUN useradd -m -u 1010 -g highvid highvid

RUN gem update --system ${RUBY_GEM_SYSTEM_VERSION}

WORKDIR /application
COPY Gemfile Gemfile.lock /application/

RUN bundle config set deployment true && \
    bundle config set frozen true && \
    bundle install

COPY --chown=highvid:higivid . /application/

USER highvid:highvid

CMD ["bundle", "exec", "scrapper.rb"]

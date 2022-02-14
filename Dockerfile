FROM ruby:3.1.0-slim

ENV TZ="America/Sao_Paulo"

ENV DIR /husky/

ARG GID=1001
ARG UID=1001

RUN apt-get update -y && apt-get install -y curl libcurl4-openssl-dev gnupg2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -y && \
    apt-get install -y build-essential libpq-dev yarn nodejs

RUN groupadd -r husky --gid ${GID} && \
    useradd --no-log-init --uid ${UID} -r -g husky -md /home/husky husky && \
    mkdir -p ${DIR}/engines

USER husky

WORKDIR ${DIR}

ADD --chown=husky:husky Gemfile* ${DIR}
RUN bundle install
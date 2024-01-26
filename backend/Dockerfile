ARG IMAGE_PROXY="" # 镜像代理，给 CI 用，加快拉取速度
ARG RUBY_IMAGE="ruby:3.2.2-slim"

FROM ${IMAGE_PROXY}${RUBY_IMAGE} AS base
ARG BUNDLER_MIRROR=""
ARG APT_MIRROR=""
WORKDIR /app
RUN if [ -n "$APT_MIRROR" ]; then \
        sed -i -E "s/deb.debian.org/${APT_MIRROR}/g" /etc/apt/sources.list.d/debian.sources \
    ; fi && \
    apt-get update -qq && apt-get install -y build-essential libvips gnupg2 curl git libmariadb-dev && \
    apt-get clean

RUN if [ -n "$BUNDLER_MIRROR" ]; then \
        gem sources --add ${BUNDLER_MIRROR} --remove https://rubygems.org/ && \
        bundle config set --local mirror.https://rubygems.org/ ${BUNDLER_MIRROR} \
    ; fi && \
    bundle config set --global path '/bundle'
ENV PATH="/bundle/ruby/$RUBY_VERSION/bin:${PATH}"
ENV BINDING="0.0.0.0"

FROM base AS prod
COPY Gemfile Gemfile.lock ./
COPY bundle /bundle
RUN bundle config set --global without "development:test" && \
    bundle install --jobs=$(nproc) # 这里不加 --clean 是因为 gems gitlab ci 缓存跟 test stage 是一样的，需要保留给他们用
COPY . .

FROM base AS dev
RUN apt-get -y install graphviz && \
    apt-get clean
COPY Gemfile Gemfile.lock ./
COPY bundle /bundle
RUN bundle install --jobs=$(nproc)
COPY . .

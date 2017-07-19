FROM alpine:3.5

RUN apk --update add erlang && rm -rf /var/cache/apk/*

ENV ELIXIR_VERSION 1.4.4

RUN apk --update add --virtual build-dependencies wget ca-certificates && \
    wget --no-check-certificate https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip && \
    mkdir -p /opt/elixir-${ELIXIR_VERSION}/ && \
    unzip Precompiled.zip -d /opt/elixir-${ELIXIR_VERSION}/ && \
    rm Precompiled.zip && \
    apk del build-dependencies && \
    rm -rf /etc/ssl && \
    rm -rf /var/cache/apk/*

ENV PATH $PATH:/opt/elixir-${ELIXIR_VERSION}/bin
ENV MIX_ENV prod

RUN mkdir /server && chmod -R 777 /server && \
    apk --no-cache add git build-base \
      erlang-dev erlang-parsetools erlang-syntax-tools \
      erlang-xmerl erlang-ssl erlang-inets erlang-public-key erlang-edoc \
      erlang-eunit erlang-tools erlang-common-test erlang-crypto erlang-asn1 && \
    mix local.hex --force && mix local.rebar --force

ADD . /app
WORKDIR /app
RUN mix do deps.get, compile

EXPOSE 3000

CMD ["mix", "phoenix.server"]
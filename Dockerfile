FROM debian:stretch-slim as seed-build

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    libboost-all-dev \
    build-essential \
    openssl \
    libssl-dev

ADD . /src

WORKDIR /src

# Needed to avoid an error compiling on alpine
RUN sed -i -e 's/^inline//g' strlcpy.h

RUN make

FROM debian:stretch-slim

COPY --from=seed-build /src/dnsseed /usr/local/bin/dnsseed

RUN apt-get update && apt-get install -y \
    libssl1.1 \
    libstdc++6

ENV APP_DIRECTORY=/data

WORKDIR ${APP_DIRECTORY}

EXPOSE 53

ENTRYPOINT ["dnsseed"]

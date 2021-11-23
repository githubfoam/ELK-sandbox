FROM alpine:3.13 as installer

ARG ES_VERSION="7.10.2"

# find the downloads for previous versions here - https://www.elastic.co/downloads/past-releases#elasticsearch-oss-no-jdk
# 7.10 is the latest version which is OSS, see - https://www.elastic.co/pricing/faq/licensing

WORKDIR /download
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${ES_VERSION}-no-jdk-linux-x86_64.tar.gz ./elasticsearch.tar.gz

RUN mkdir /elasticsearch && \
    tar -xzf elasticsearch.tar.gz --strip-components=1 -C /elasticsearch
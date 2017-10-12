FROM ubuntu:16.04
MAINTAINER Seth Fitzsimmons <seth@mojodna.net>

ENV DEBIAN_FRONTEND noninteractive

# might be better as a PPA
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    debhelper \
    dh-autoreconf \
    autotools-dev \
    zlib1g-dev \
    libjasper-dev \
    libpng-dev \
    libgif-dev \
    libwebp-dev \
    libhdf5-dev \
    libpcre3-dev \
    libxerces-c-dev \
    d-shlibs \
    libgeos-dev \
    python-all-dev \
    python-numpy \
    libsqlite3-dev \
    libexpat1-dev \
    libproj-dev \
    libxml2-dev \
    libspatialite-dev \
    liblzma-dev \
    libopenjp2-7-dev \
    libarmadillo-dev \
    liburiparser-dev \
    pkg-config \
    libgnutls-dev \
  && mkdir /tmp/nghttp2 \
  && curl -sfL https://github.com/nghttp2/nghttp2/releases/download/v1.26.0/nghttp2-1.26.0.tar.gz | tar zxf - -C /tmp/nghttp2 --strip-components=1 \
  && cd /tmp/nghttp2 \
  && ./configure --enable-lib-only \
  && make -j $(nproc) install \
  && mkdir /tmp/curl \
  && curl -sfL https://curl.haxx.se/download/curl-7.56.0.tar.gz | tar zxf - -C /tmp/curl --strip-components=1 \
  && apt remove -y curl libcurl3-gnutls \
  && apt autoremove -y \
  && cd /tmp/curl \
  && ./configure --prefix=/usr --disable-manual --disable-cookies --with-gnutls \
  && make -j $(nproc) install \
  && ldconfig \
  && cd / \
  && rm -rf /tmp/curl /tmp/nghttp2 \
  && mkdir -p /tmp/gdal \
  && curl -sfL https://github.com/OSGeo/gdal/archive/5c1e079.tar.gz | tar zxf - -C /tmp/gdal --strip-components=2 \
  && cd /tmp/gdal \
  && ./configure \
    --prefix=/usr \
    --mandir=/usr/share/man \
    --includedir=/usr/include/gdal \
    --with-threads \
    --with-grass=no \
    --with-hide-internal-symbols=yes \
    --with-rename-internal-libtiff-symbols=yes \
    --with-rename-internal-libgeotiff-symbols=yes \
    --with-libtiff=internal \
    --with-geotiff=internal \
    --with-webp \
    --with-jasper \
    --with-jpeg=internal \
    --with-hdf5=/usr/lib/x86_64-linux-gnu/hdf5/serial \
    --with-xerces \
    --with-geos \
    --with-sqlite3 \
    --with-curl \
    --with-static-proj4=yes \
    --with-spatialite=/usr \
    --with-cfitsio=no \
    --with-ecw=no \
    --with-mrsid=no \
    --with-openjpeg=yes \
    --with-armadillo=yes \
    --with-liblzma=yes \
  && make -j $(nproc) \
  && make install \
  && cd / \
  && rm -rf /tmp/gdal \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
ENV GDAL_HTTP_VERSION 2

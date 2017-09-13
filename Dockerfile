FROM ubuntu:16.04
MAINTAINER Seth Fitzsimmons <seth@mojodna.net>

ENV DEBIAN_FRONTEND noninteractive

# build dependencies + configure args from gdal-bin minus libjpeg
# would be better as a PPA
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
    libnetcdf-dev \
    netcdf-bin \
    libjasper-dev \
    libpng-dev \
    libgif-dev \
    libwebp-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libpcre3-dev \
    libpq-dev \
    libxerces-c-dev \
    unixodbc-dev \
    doxygen \
    d-shlibs \
    libgeos-dev \
    dh-python \
    python-all-dev \
    python-numpy \
    libcurl4-gnutls-dev \
    libsqlite3-dev \
    libogdi3.2-dev \
    chrpath \
    swig \
    patch \
    libexpat1-dev \
    libproj-dev \
    libdap-dev \
    libxml2-dev \
    libspatialite-dev \
    libepsilon-dev \
    libpoppler-private-dev \
    liblzma-dev \
    libopenjp2-7-dev \
    libarmadillo-dev \
    libfreexl-dev \
    libkml-dev \
    liburiparser-dev \
  && apt-get clean \
  && mkdir -p /tmp/gdal \
  && curl -sfL http://download.osgeo.org/gdal/2.2.1/gdal-2.2.1.tar.gz | tar zxf - -C /tmp/gdal --strip-components=1 \
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
    --with-netcdf \
    --with-hdf5=/usr/lib/x86_64-linux-gnu/hdf5/serial \
    --with-xerces \
    --with-geos \
    --with-sqlite3 \
    --with-curl \
    --with-pg \
    --with-python \
    --with-odbc \
    --with-ogdi \
    --with-dods-root=/usr \
    --with-static-proj4=yes \
    --with-spatialite=/usr \
    --with-cfitsio=no \
    --with-ecw=no \
    --with-mrsid=no \
    --with-poppler=yes \
    --with-openjpeg=yes \
    --with-freexl=yes \
    --with-libkml=yes \
    --with-armadillo=yes \
    --with-liblzma=yes \
    --with-epsilon=/usr \
  && make -j $(nproc) \
  && make install \
  && cd / \
  && rm -rf /tmp/gdal \
  && rm -rf /var/lib/apt/lists/*

ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

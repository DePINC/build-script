IMAGENAME=depinc.org/depinc-build
IMAGEVERSION?=0.0.1-bionic

PROXY_HOST_PORT=127.0.0.1:8080
CMAKE_VERSION=v3.16.9

BASEDIR = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

all: build-all

build-all: images
	$(BASEDIR)/build.sh

images: image_x86_64-w64-mingw32 image_x86_64-linux-gnu

# Windows x86_64
image_x86_64-w64-mingw32:
	cd $(BASEDIR)/images && docker build --network host --build-arg PROXY_HOST_PORT=$(PROXY_HOST_PORT) --build-arg CMAKE_VERSION=$(CMAKE_VERSION) -f Dockerfile.x86_64-w64-mingw32 -t $(IMAGENAME):$(IMAGEVERSION)-x86_64-w64-mingw32 .
build_x86_64-w64-mingw32: image_x86_64-w64-mingw32
	HOSTS=x86_64-w64-mingw32 PROXY_HOST_PORT=$(PROXY_HOST_PORT) $(BASEDIR)/build.sh

# Linux x86_64
image_x86_64-linux-gnu:
	cd $(BASEDIR)/images && docker build --network host --build-arg PROXY_HOST_PORT=$(PROXY_HOST_PORT) --build-arg CMAKE_VERSION=$(CMAKE_VERSION) -f Dockerfile.x86_64-linux-gnu -t $(IMAGENAME):$(IMAGEVERSION)-x86_64-linux-gnu .
build_x86_64-linux-gnu: image_x86_64-linux-gnu
	HOSTS=x86_64-linux-gnu PROXY_HOST_PORT=$(PROXY_HOST_PORT) $(BASEDIR)/build.sh

.PHONY: build-all images

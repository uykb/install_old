#!/bin/bash

if [ ! -d libsodium-1.0.1 ]; then
    wget https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/ss-panel/libsodium-1.0.10.tar.gz || exit 1
    tar xf libsodium-1.0.10.tar.gz || exit 1
fi
pushd libsodium-1.0.10
./configure && make -j2 && make install || exit 1
ldconfig
popd

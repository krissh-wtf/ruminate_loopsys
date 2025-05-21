#!/bin/env sh

if [ -d bin ]; then
  rm -rf bin
fi

mkdir bin
rojo build --output bin/loopsys.rbxl
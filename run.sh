#!/bin/bash

if cmake --build ./build -j $(nproc) --config Debug; then
	ctest --test-dir ./build -j $(nproc) --verbose
fi

#!/usr/bin/env bash

for d in {mod,app}{1,2}; do cd $d; pnpm install; cd ..; done

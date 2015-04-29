#!/bin/bash

cd "$(dirname ""$0"")"

rm -rvf ~/.vagrant.d/tmp/*
rm -rvf ~/.vagrant.d/gems/*
rm -vf ~/.vagrant.d/plugins.json

echo 1.1 > ~/.vagrant.d/setup_version

exit 0

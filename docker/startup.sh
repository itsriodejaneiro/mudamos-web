#! /bin/sh

./docker/prepare-db.sh
bundle exec puma -C config/puma.rb


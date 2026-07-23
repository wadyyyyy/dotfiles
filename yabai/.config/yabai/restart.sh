#!/usr/bin/env sh

yabai --restart-service &
skhd --restart-service &
brew services restart borders &
sketchybar --reload &

wait

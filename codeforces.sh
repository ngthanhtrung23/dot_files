#!/bin/bash

# Remove all files
mv template.cpp ../template.cpp
rm -rf *
rm -rf .*.swp
mv ../template.cpp template.cpp

# Change to minimized vimrc
cp ~/.vimrc.min ~/.vimrc

# Make input / output empty
rm -f input.txt
rm -f output.txt
touch input.txt
touch output.txt

#!/bin/bash

convert $1 \( +clone -background black -shadow 55x15+0+5 \) +swap -background none -layers merge  +repage new.png

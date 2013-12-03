#!/bin/bash
mplayer -tv driver=v4l2:gain=1:width=640:height=480:device=/dev/video0 tv://

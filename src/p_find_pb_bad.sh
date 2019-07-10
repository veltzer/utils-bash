#!/bin/bash
find -L . -name "*-lrg.jpg" -or -name "*-med.jpg" | fgrep -v pb > err_pb.txt

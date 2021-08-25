#!/bin/bash -e
find -L . -name "*-lrg.jpg" -or -name "*-med.jpg" | grep -F -v pb > err_pb.txt

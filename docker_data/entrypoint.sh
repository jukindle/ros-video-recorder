#!/bin/bash

# Source the ROS environment
source /catkin_ws/devel/setup.bash

# Parse arguments using argparse in Python
cmd=$(python /entrypoint.py ${@:1:99})
eval $cmd

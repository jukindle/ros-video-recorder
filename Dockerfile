# Use the official image as a parent image.
FROM ros:melodic
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash"

# Update apt indices
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt update --fix-missing
#
# # Install apt dependencies
RUN apt update && apt install -y \
  python-catkin-tools \
  ros-melodic-cv-bridge
#   python-rosdep \
#   ros-melodic-tf \
#   ros-melodic-velodyne-gazebo-plugins \
#   ros-melodic-velodyne-description \
#   ros-melodic-hector-gazebo-plugins \
#   ros-melodic-urdf \
#   ros-melodic-xacro \
#   libeigen3-dev \
#   ros-melodic-controller-manager-msgs \
#   ros-melodic-control-msgs \
#   python3 python3-pip \
#   gstreamer1.0-tools gstreamer1.0-libav libgstreamer1.0-dev \
#   libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev \
#   gstreamer1.0-plugins-good gstreamer1.0-plugins-base \
#   ros-melodic-rgbd-launch \
#   ros-melodic-camera-calibration-parsers \
#   ros-melodic-camera-info-manager \
#   ros-melodic-gazebo-plugins

# Set the working directory.
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws
RUN catkin init
RUN catkin config --extend /opt/ros/melodic
RUN catkin config --merge-devel
RUN catkin config -DCMAKE_BUILD_TYPE=Release

# Move content of this folder to container
RUN mkdir src/ros-video-recorder
COPY . src/ros-video-recorder/

# Build the workspace
RUN catkin build video_recorder

# Setup docker interface
COPY docker_data/entrypoint.sh /
COPY docker_data/entrypoint.py /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["record"]
RUN chmod +x /entrypoint.sh
RUN chmod +x /entrypoint.py
RUN mkdir /OUTPUT

# Clean image to reduce size
RUN rm -rf /var/lib/apt/lists/*

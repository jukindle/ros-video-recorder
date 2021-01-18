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
  ros-melodic-cv-bridge \
  ffmpeg

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

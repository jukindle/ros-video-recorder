# ros-image-recorder

Image Record Package for ROS.

## Why is this ros package special?
 
1. Images shouldn't have to be published in a precise interval.
  + If you have a node which computes heavily using image, drawing results on a input image might be delayed. 

2. Multiple image topics can be merged in a grid view.
  + Log your robot's data in multiple video files can be frustrating, if you have a multiple cameras and multiple calculation nodes.

3. etc.

## image_recorder node

This node use opencv to save video, subscribe multiple image-publishing nodes.

### Parameters

+ ~output_width(int: default 640) : Output video width.
+ ~output_height(int: default 480) : Output video height.
+ ~output_fps(int: default 30) : Output video fps(frame per seconds).
+ ~output_format(str: default xvid) : Output video format in fourcc format. See [FourCC Identifier](https://www.fourcc.org/codecs.php)
+ ~output_path(str) : Output Video File Path. eg: /home/ildoonet/Documents/video.mp4

+ ~source1(str) : Incoming Video Frame Info in Format(topic,target_x,target_y,target_w,target_h)
  + eg: "/cv_camera/image_raw,0,0,320,240"
  + Source image will be resized automatically at target_w, target_h
  + Resized image will be pasted at the position of (target_x, target_y)
  
### Examples

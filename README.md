# ros-image-recorder

Image Record Package for ROS.

## Why is this ros package special?

1. Images shouldn't have to be published in a precise interval.
  + If you have a node which computes heavily using image, drawing results on a input image might be delayed.
  + Images can be Published in a different fps with output video.
  + Images can be published in a variable interval.

2. Multiple image topics can be merged in a grid view.
  + Log your robot's data in multiple video files can be frustrating, if you have a multiple cameras and multiple calculation nodes.
  + Publishing Interval(fps) can be different for camera nodes.

3. etc.

## image_recorder node

This node use opencv to save video, subscribe multiple image-publishing nodes.

### Parameters
+ ~source(str) : Incoming Video in case that only one source is used (num_videos == 0).
+ ~output_fps(int: default 30) : Output video fps(frame per seconds).
+ ~output_format(str: default xvid) : Output video format in fourcc format. See [FourCC Identifier](https://www.fourcc.org/codecs.php)
+ ~output_path(str: default ros_recording.avi) : Output Video File Path. eg: /home/ildoonet/Documents/video.mp4
  + [timestamp] : will be replaced with real timestamp. eg. grid_[timestamp].mp4 ---> grid_20170626_185926.mp4
+ ~output_topic(str) : Broadcast Output Video, if provided. eg. /image_recorder/image_raw


+ ~num_videos(str: default 0) : Number of ~source&lt;i&gt; topics to subscribe to, starting from 1. In case that num_videos is 0, the only subscription is the ~source topic.
+ ~source&lt;i&gt;(str) : Incoming Video Frame Info for input &lt;i&gt;<i> (with &lt;i&gt; starting at 1 up to num_videos) in Format(topic,target_x,target_y,target_w,target_h)
  + eg: "/cv_camera/image_raw,0,0,320,240"
  + Source image will be resized automatically at target_w, target_h
  + Resized image will be pasted at the position of (target_x, target_y)
  + ~source{n} : n is {1, 2, 3, ...}.
+ ~output_width(int: default 0) : Output video width, only used when multiple cameras are specified. If set to zero, the size will be automatically calculated to fit all sources into the resulting video.
+ ~output_height(int: default 0) : Output video height, only used when multiple cameras are specified. If set to zero, the size will be automatically calculated to fit all sources into the resulting video.
### Examples

#### Single source (rosrun)

```bash
rosrun video_recorder recorder.py _source:=/realsense/color/image_raw _output_path:=demo_recording.avi
```
Records from topic `/realsense/color/image_raw` with the image width and height taken from the first message that arrives and stores the output to `./demo_recording.avi`.

#### Side-by-side (rosrun)
```bash
rosrun video_recorder recorder.py _num_videos:=2 \
 _source1:=/realsense/color/image_raw,0,0,960,540 \
 _source2:=/realsense/confidence/image_rect_raw,960,0,720,540 \
  _output_path:=demo_recording_sidebyside.avi

```
Records a video from two image sources where the first image from source `/realsense/color/image_raw` starts at (x,y)=(0,0) and has (width,height)=(960,540) (actually the original quality) and the second image from source `/realsense/confidence/image_rect_raw` starts at (x,y)=(960,0) with (width,height)=(729,540) (upscaled to have the same height as the first image). The width and height of the output video will be such that all frames completely fit inside (in this case, 1680x540).

![Side by Side example](/samples/side_by_side.png)


#### 2 by 2 Grid with 3 Camera/Image Topics (roslaunch)

![2x2 grid sample](/samples/2x2grid.png)

```xml
<node name="video_recorder" pkg="video_recorder" type="recorder.py" output="screen" required="true">

    <param name="output_width" type="int" value="640" />
    <param name="output_height" type="int" value="480" />
    <param name="output_path" value="/workdir/result.avi" />

    <param name="output_topic" value="$(arg video_topic)" />
    <param name="num_videos" value="3" />

    <param name="source1" value="/videofile/image_raw,0,0,320,240" />         <!-- left-top -->
    <param name="source2" value="/openpose/image_raw,320,0,320,240" />        <!-- right-top -->
    <param name="source3" value="/deepdrone/facetrack_img,0,240,320,240" />   <!-- right-bottom -->

</node>

<node name="image_view_grid" pkg="image_view" type="image_view" respawn="false" output="screen" required="true">
    <remap from="image" to="$(arg video_topic)"/>
    <param name="autosize" value="true" />
</node>
```

![3x3 grid sample - not same size](/samples/3x3grid_multi_size.png)

```xml
<node name="video_recorder" pkg="video_recorder" type="recorder.py" output="screen" required="true">

    <param name="output_width" type="int" value="640" />
    <param name="output_height" type="int" value="480" />
    <param name="output_path" value="/workdir/result.avi" />

    <param name="output_topic" value="$(arg video_topic)" />
    <param name="num_videos" value="4" />

    <param name="source1" value="/videofile/image_raw,0,0,640,480" />         <!-- left-top with big size(640x480) -->
    <param name="source2" value="/openpose/image_raw,640,0,320,240" />        <!-- right-top (320x240) -->
    <param name="source3" value="/deepdrone/facetrack_img,640,240,320,240" />   <!-- right-bottom (320x240) -->
    <param name="source4" value="/deepdrone/tracking_img,0,480,320,240" />    <!-- left-bottom (320x240) -->

</node>

<node name="image_view_grid" pkg="image_view" type="image_view" respawn="false" output="screen" required="true">
    <remap from="image" to="$(arg video_topic)"/>
    <param name="autosize" value="true" />
</node>
```

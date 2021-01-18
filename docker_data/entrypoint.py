import subprocess
import argparse


# Set up main parser
parser = argparse.ArgumentParser(description='A video recorder for ROS Image topics.')
subparsers = parser.add_subparsers(dest='command', help='Commands')

# Set up bash mode parser
parser_bash = subparsers.add_parser('bash_mode', help='''Start interactive bash
                                    shell.''')

# Set up simulation starter
parser_record = subparsers.add_parser('record', help='''Launches the recorder.''')
parser_record.add_argument('input_videos', nargs='*')
parser_record.add_argument('--output_filename', help='''Output filename.''',
                        default="ros_recording.avi")
parser_record.add_argument('--ROS_args', nargs='*')

# Parse arguments
args = parser.parse_args()
cmd = ''

# Bash mode
if args.command == 'bash_mode':
    cmd = '''/bin/bash'''

# Start simulation
if args.command == 'record':
    if len(args.input_videos) == 0:
        print("echo 'Error: at least one video must be specified.';")
        exit()
    elif len(args.input_videos) == 1:
        recorder_args = "_source:={} _output_path:=/OUTPUT/{}".format(args.input_videos[0], args.output_filename)
    else:
        recorder_args = "_num_videos:={} _output_path:=/OUTPUT/{}".format(len(args.input_videos), args.output_filename)
        for i in range(len(args.input_videos)):
            recorder_args += " _source{}:={}".format(i+1, args.input_videos[i])
    ros_args = ' '.join(args.ROS_args) if args.ROS_args is not None else ''
    cmd += "rosrun video_recorder "
    cmd += "recorder.py {} {};".format(recorder_args, ros_args)

# Give commands back to shell script
print(cmd)

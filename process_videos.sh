#!/usr/bin/env bash

videos_list=~/Desktop/extracted_sequences_MOV/*.MOV
remote_addr=nvidia@172.16.0.8
remote_video_dir=/home/nvidia/Desktop
darknet_path=/home/nvidia/Workspace/darknet
yolo_cmd='./darknet detector demo cfg/coco.data cfg/yolo.cfg yolo.weights'

for filepath in $videos_list; do
        echo $filepath
        filename=$(basename $filepath)
        scp $filepath $remote_addr:$remote_video_dir
        remote_video_path="$remote_video_dir/$filename"
        cmd="${yolo_cmd} $remote_video_path"
        output_logs_file="${filename}_yolo.csv"
        ssh $remote_addr "cd $remote_video_dir; ls -la $filename; cd $darknet_path; pwd; $cmd; ls -la logs.txt; mv logs.txt $output_logs_file; rm $remote_video_path; ls -la $remote_video_path"
done

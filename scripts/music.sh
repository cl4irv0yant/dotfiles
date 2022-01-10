#!/bin/bash

# Check if the URL is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube URL>"
    exit 1
fi

# Define the output pattern for yt-dlp
OUTPUT_PATTERN="%(title)s.%(ext)s"

# Extract audio from YouTube link
yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 "$1" -o "$OUTPUT_PATTERN"

# Directly compute the expected filename based on the naming pattern
OUTPUT_FILENAME=$(yt-dlp "$1" --get-title) 
OUTPUT_FILENAME="${OUTPUT_FILENAME}.mp3"

# Check if the file exists
if [ ! -f "$OUTPUT_FILENAME" ]; then
    echo "Error: File not found!"
    exit 1
fi

# Copy the audio file to the remote
scp "$OUTPUT_FILENAME" admin@192.168.1.111:/mnt/pool/data/media/music

# Check the status of scp
if [ $? -eq 0 ]; then
    echo "File copied successfully!"
else
    echo "Error while copying the file!"
fi


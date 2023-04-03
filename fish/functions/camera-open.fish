function camera-open -d "Open a phone camera V4L2 device"
    # Connect to the phone.
    adb start-server
    and adb forward tcp:9009 tcp:9009

    # Set up v4l2loopback
    and sudo modprobe v4l2loopback exclusive_caps=1
    and ffmpeg -i http://localhost:9009/video -vf format=yuv420p -f v4l2 /dev/video0
end

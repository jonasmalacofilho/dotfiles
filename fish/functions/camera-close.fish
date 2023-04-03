function camera-close -d "Close the phone camera V4L2 device"
    # Cleanup
    adb forward --remove tcp:9009
    sudo modprobe -r v4l2loopback
    adb kill-server
end

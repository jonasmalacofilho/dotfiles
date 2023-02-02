function v4l2phone_shutdown -d "Shutdown the phone camera V4L2 device"
    # Cleanup
    adb forward --remove tcp:9009
    and sudo modprobe -r v4l2loopback
    and adb kill-server
end

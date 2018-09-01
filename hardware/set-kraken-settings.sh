#!/bin/bash -x

# Configure the Kraken X62
#
# Besides propagating error codes, uses the ring LEDs to convey to the user, in
# a visual way,  progression and eventual failures.  This makes the script
# suitable for unattained operation, such as automated configuration during
# boot.
#
# However, the settings listed here are for my particular setup, and should
# only be used as reference, if that.  Even so, they consider a Kraken X62 as
# top exaust, with NF-A14s fans in the pull configuration, and a happy 8700K.

function panic() {
	set code=$?
	liquidctl --device 0 set ring color pulse ff2608 --speed faster
	exit $code
}

liquidctl --device 0 set sync color super af5a2f 000000 000000 000000 000000 000000 000000 000000 000000 || panic

# compensate for increased liquid temperature from gpu
liquidctl --device 0 set fan speed 22 30 36 90 40 100 || panic
liquidctl --device 0 set ring color super 000000 af5a2f af5a2f af5a2f 000000 000000 000000 000000 000000 || panic

# the benefits of running the pump above 60% are almost imperceptible
liquidctl --device 0 set pump speed 60 || panic
liquidctl --device 0 set ring color fixed af5a2f || panic

# discretely let the user know that all is well
sleep 1
liquidctl --device 0 set ring color covering-marquee af5a2f || panic


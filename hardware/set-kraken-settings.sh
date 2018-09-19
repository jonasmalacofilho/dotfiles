#!/bin/bash -x

# Configure my Kraken X62 and Smart Device
#
# Besides propagating error codes, uses the LEDs to convey to the user, in
# a visual way,  progression and eventual failures.  This makes the script
# suitable for unattained operation, such as automated configuration during
# boot.


KRAKEN="--device 0"
# The settings listed here are for my particular setup, and should only be used
# as reference, if that.  Even so, they consider a Kraken X62 as top exaust,
# with NF-A14s fans in the pull configuration, and a happy 8700K.

function kraken_panic() {
	code=$?
	liquidctl $KRAKEN set ring color pulse ff2608 --speed faster
	exit $code
}

liquidctl $KRAKEN set sync color super-fixed af5a2f || kraken_panic

liquidctl $KRAKEN set fan speed 30 60 36 90 40 100 || kraken_panic
liquidctl $KRAKEN set ring color super-fixed 000000 af5a2f af5a2f af5a2f || kraken_panic

liquidctl $KRAKEN set pump speed 30 60 36 90 40 100 || kraken_panic
liquidctl $KRAKEN set ring color fixed af5a2f || kraken_panic

sleep 1
liquidctl $KRAKEN set ring color covering-marquee af5a2f || kraken_panic


SMART_DEVICE="--device 1"

function smart_device_panic() {
	code=$?
	liquidctl $SMART_DEVICE set led color pulse 500804 --speed faster
	exit $code
}

liquidctl $SMART_DEVICE reset || smart_device_panic

for i in {1..2};
do
	liquidctl $SMART_DEVICE set fan$i speed 40 || smart_device_panic
done

liquidctl $SMART_DEVICE set led color off || smart_device_panic


sleep 10;
liquidctl status


#!/bin/bash -xe

# Configure my Kraken X62 and Smart Device
#
# Besides propagating error codes, uses the Kraken LEDs to convey to the user,
# in a visual way, progression and eventual failures.  This makes the script
# suitable for unattained operation, such as automated configuration during
# boot.

KRAKEN="--vendor 0x1e71 --product 0x170e"
SMART_DEVICE="--vendor 0x1e71 --product 0x1714"

function panic() {
	code=$?
	liquidctl $KRAKEN set ring color pulse ff2608 --speed faster
	exit $code
}

liquidctl $SMART_DEVICE initialize || panic
liquidctl $KRAKEN set sync color off || panic
liquidctl $KRAKEN set logo color fixed 8c5a24 || panic
liquidctl $SMART_DEVICE set led color off || panic

liquidctl $KRAKEN set fan speed 30 60 45 100 || panic
liquidctl $KRAKEN set pump speed 30 50 40 100 || panic
liquidctl $SMART_DEVICE set fan1 speed 50 || panic
liquidctl $SMART_DEVICE set fan2 speed 50 || panic
liquidctl $SMART_DEVICE set fan3 speed 50 || panic

sleep 3
liquidctl $KRAKEN set ring color covering-marquee 8c5a24 --speed faster || panic
liquidctl $SMART_DEVICE set led color covering-marquee 40260a --speed slowest || panic

# liquidctl $SMART_DEVICE set led color super-fixed \
# 	522132 871f3f 7c2519 5f3c1a 325516 \
# 	2a401c 194f46 372e63 50259b 762264 \
# 	522132 871f3f 7c2519 5f3c1a 325516 \
# 	2a401c 194f46 372e63 50259b 762264 \
# 	|| panic

# http://tools.medialab.sciences-po.fr/iwanthue/
# https://color.adobe.com/create/color-wheel
# https://stackoverflow.com/questions/15282580/how-to-generate-a-number-of-most-distinctive-colors-in-r


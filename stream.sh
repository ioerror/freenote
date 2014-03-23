#!/usr/bin/env bash

set -ex

main() {
  # Your audio device
  # Find the correct audio device with with `pactl list`
  : ${AUDIODEVICE:=alsa_input.usb-046d_HD_Pro_Webcam_C920_6DBE3ADF-02-C920.analog-stereo}
  : ${VIDEODEVICE:=/dev/video0}
  #
  # Assuming that you're authorized by the FSF - the video should be available
  # here:
  #
  #   http://live.fsf.org/keynote.ogv
  #
  : ${SERVER:=live.fsf.org}
  : ${IP:=18.4.89.36}
  : ${PORT:=80}
  : ${MOUNTPOINT:=/keynote.ogv}
  # Replace this with the correct password, of course
  : ${PASSWORD:=GnUisL1ve}
  : ${LOCALIP:=127.0.0.1}
  : ${LOCALPORT:=8080}
  : ${OVERLAYTEXT:="Anonymously streamed over Tor"}
  : ${FRAMERATE:=10}
  echo $AUDIODEVICE
  stream
}

# Audio and video streaming on Tor Hidden Service and streaming to FSF
stream() {
  usewithtor gst-launch-0.10 \
  v4l2src ! \
  video/x-raw-yuv,device="$VIDEODEVICE",width="640,height=480,framerate=(fraction)$FRAMERATE/1" ! queue ! \
  textoverlay shaded-background=true text="$OVERLAYTEXT" !\
  ffmpegcolorspace ! tee name=localview ! theoraenc ! queue ! \
  oggmux name=mux pulsesrc device="$AUDIODEVICE" ! queue ! \
  audioconvert ! vorbisenc ! queue ! mux. mux. ! queue ! \
  tee name=shout ! tee name=fileout ! tcpserversink  host="$LOCALIP" \
  port="$LOCALPORT" shout. ! queue ! \
  shout2send ip="$IP" port="$PORT" password="$PASSWORD" mount="$MOUNTPOINT" \
  fileout. ! queue ! filesink sync=false location="video-`date +%s`.ogv" \
  localview. ! queue ! xvimagesink sync=false
}

[ "${BASH_SOURCE[0]}" == "$0" ] && main "$@"
:

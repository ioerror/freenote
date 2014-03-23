freenote
========

Helpful utilities and documentation for Free Software live audio/video streaming

Overview
========

Why not replace Skype and Google Hangout with a Free Software solution that
respects your privacy, security, anonymity and your liberty? Thanks to
gstreamer, Tor and other tools, we can easily stream video anonymously and
securely!

The goal of this project is to open a local video display showing a camera
feed, to stream to a remote video share server as well as to provide a Tor
Hidden service where a remote user may stream video in a purely peer to peer
fashion without a third party.

In addition to a remote OGG video stream available on a Tor Hidden Service and
a remote shoutcast server, it also records a local copy of the video in a Free
format to your system.

Requirements
============

This has been tested on a Debian machine running a mix of stable and testing.
Please install the following software packages:

  tor
  torsocks
  gstreamer0.10-plugins-{good,bad,ugly,base,base-apps}
  gstreamer0.10-{pulseaudio,x,alsa,ffmpeg,tools,doc}

The Debian machine should use pulse audio, though future versions may automatically
discover and configure audio devices.

Details
=======

This is specifically configured for streaming 640x480 video with a text overlay
using a common Logitech HD USB camera.

To serve video over a Tor Hidden Service, you will need to add the following to
your Tor configuration file:

  HiddenServiceDir /var/lib/tor/hidden_service_video_streamer/
  HiddenServicePort 80 127.0.0.1:8080

After reconfiguring, share the hostname found in the following file:

  /var/lib/tor/hidden_service_video_streamer/hostname

Viewing the video and audio stream
==================================

With Tor Browser, one can directly watch the video without any additional
software:

  `http://ylq7gsof3t3wrdkz.onion`

It is also possible to watch the video stream with cvlc (configure vlc to use
Tor as a SOCKS proxy):

  `cvlc tcp://ylq7gsof3t3wrdkz.onion`

Mplayer and netcat may also work:

  `usewithtor nc ylq7gsof3t3wrdkz.onion 80| mplayer -cache 32 - `

Install the required packages, configure Tor and run `stream.sh` - it should
Just Work!

Contact
=======

Send feedback to jacob at appelbaum dot net

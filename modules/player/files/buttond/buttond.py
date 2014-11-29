#!/usr/bin/env python

import RPi.GPIO as GPIO
import time
import subprocess
import os
import sys

# TODO this is perfunctory. Not resilliant to SIGHUP, zombie-ing, etc. Seems to serve our purposes though. See http://code.activestate.com/recipes/278731-creating-a-daemon-the-python-way/
print( "Forking into the background" )
if os.fork():
    sys.exit()

def toggle( channel ):
    print( "Pin {} pressed".format( channel ) )
    subprocess.call( [ "mpc", "toggle" ] )

def next( channel ):
    print( "Pin {} pressed".format( channel ) )
    subprocess.call( [ "mpc", "next" ] )

GPIO.setmode( GPIO.BOARD )

pins = { toggle: 5, next: 3 }

for pin in pins:
    print( "setting up pin {} to call {}".format( pins[pin], pin ) )
    GPIO.setup( pins[pin], GPIO.IN, pull_up_down=GPIO.PUD_DOWN )
    GPIO.add_event_detect( pins[pin], GPIO.FALLING, callback=pin, bouncetime=200 )

while True:
    time.sleep( 1 )

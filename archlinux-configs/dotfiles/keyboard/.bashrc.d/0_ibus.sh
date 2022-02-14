#!/bin/bash

# Use IBus as input method, ensuring that the custom keyboard layout is used
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
# Does the second line cause problems with Qt/KDE?

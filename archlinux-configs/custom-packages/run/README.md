A very simple script for running programs in the background and independently
from the original terminal.

The simple python script starts by forking. The original process ends, while
the background process calls bash with the given command.

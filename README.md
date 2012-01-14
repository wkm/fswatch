# fswatch
A super trivial Ruby script for triggering a command on file system change in OS X.

## Installation

The point was mainly to shove this into gemcutter so it's easy to deploy:

	$ gem install fswatch

## Usage

On file system change execute `ls -l`:

    $ fswatch ls -l
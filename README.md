# fswatch
A trivial Ruby script for triggering a command on file system change in OS X.

## Installation

The point was mainly to shove this into gemcutter so it's easy to deploy:

	$ gem install fswatch

## Usage

On file system change execute `ls -l`:

    $ fswatch ls -l

Watch a specific path:

	$ fswatch -d / ls -l

Wait at least 5 seocnds before refreshing using deferral:

	$ fswatch -t5 ls -l

If the command is long running and you want to forcibly restart it on file system change:

	$ fswatch -x ls -l

If you want to pass the paths which have changed as a parameter to the command:

	$ fswatch -p echo

If you want to place the paths somewhere other than at the end, use the `@fspaths` token:

	$ fswatch -p "echo @fspaths | wc -l"

You can also use `@fspathscolon` for colon-separated paths and `@fspatchcomma` for comma-separated paths.

## Examples

	$ fswatch rsync -av . devbox:/devfolder-on-devbox/
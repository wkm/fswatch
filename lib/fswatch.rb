require 'fswatch/version'

require 'trollop'
require 'rb-fsevent'
require 'term/ansicolor'

include Term::ANSIColor

module FSWatch

	opts = Trollop::options do
		version "fswatch - #{VERSION} (c) 2012 w.k.macura - Released under BSD license"
		banner <<-EOS
A utility for triggering a command on file system change.
		EOS

		opt :throttle, "only allow one fsevent in the given amount of seconds", :default => 1
		opt :kill, "forcibly restart the command if it's still running during an fs trigger", :short => :x
		opt :paths, "append the changed paths when calling the command"
	end
	  
  fsevent = FSEvent.new
  fsevent.watch Dir.pwd do |directories|
    print red, "\n\n--- Changed: ", bold, blue, directories.inspect, reset, "\n"
    if @process && !@process.exited?
    	print red, "!!! Sending kill: #{@process.pid}", reset, "\n"
  		@process.kill
  	end

    command = ARGV.join(' ')
    command.sub("$fspathscolon", directories.join(':'))
    command.sub("$fspathscomma", directories.join(','))
    command.sub("$fspaths", directories.join(' '))

    if opts[:paths]
    	command << ' ' << directories.join(' ')
    end

    p command
     
    @process = fork do 
			system(command)
		end
  end
  
  fsevent.run
end

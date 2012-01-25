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

		opt :dir, "the directory to watch", :default => '.'
		opt :throttle, "only allow one fsevent in the given amount of seconds", :default => 1
		opt :kill, "forcibly restart the command if it's still running during an fs trigger", :short => :x
		opt :paths, "append the changed paths when calling the command"
	end
	  
	if opts[:dir] == '.'
		dir = Dir.pwd
	else
		dir = opts[:dir]
	end

  fsevent = FSEvent.new 
  fsevent.watch dir, { :latency => opts[:throttle], :no_defer => true } do |directories|
    print red, "\n\n--- Changed: ", bold, blue, directories.inspect, reset, "\n"
    if @process && !@process.exited?
    	print red, "!!! Sending kill: #{@process.pid}", reset, "\n"
  		@process.kill
  	end

    command = ARGV.join(' ')
    command.sub!("@fspathscolon", directories.join(':'))
    command.sub!("@fspathscomma", directories.join(','))
    command.sub!("@fspaths", directories.join(' '))

    if opts[:paths]
    	command << ' ' << directories.join(' ')
    end
     
    fork do 
			system(command)
		end
		@process = $?
  end
  
  fsevent.run
end

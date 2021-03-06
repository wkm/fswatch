require 'fswatch/version'

require 'rubygems'
require 'trollop'
require 'rb-fsevent'
require 'term/ansicolor'

include Term::ANSIColor

module FSWatch

  def FSWatch.run_command(directories)
    print red, "\n\n--- Changed: ", bold, blue, directories.inspect, reset, "\n"
    if @processPid 
      status = Process.wait(@processPid, Process::WNOHANG)
      if @opts[:kill] && status == nil
        print red, "!!! Killing #{@processPid}", reset, "\n"
        Process.kill("KILL", @processPid)
      end
    end

    command = ARGV.join(' ')
    command.sub!("@fspathscolon", directories.join(':'))
    command.sub!("@fspathscomma", directories.join(','))
    command.sub!("@fspaths", directories.join(' '))

    if @opts[:paths]
      command << ' ' << directories.join(' ')
    end
     
    @processPid = fork {
      system(command)
    }
  end


	@opts = Trollop::options do
		version "fswatch - #{VERSION} (c) 2012 w.k.macura - Released under BSD license"
		banner <<-EOS
A utility for triggering a command on file system change.
		EOS

    opt :start, "whether the command should be executed immediately on start", :default => true
		opt :dir, "the directory to watch", :default => '.'
		opt :throttle, "only allow one fsevent in the given amount of seconds", :default => 1
		opt :kill, "forcibly restart the command if it's still running during an fs trigger", :short => :x, :default => false
		opt :paths, "append the changed paths when calling the command"
	end
	  
	if @opts[:dir] == '.'
		dir = Dir.pwd
	else
		dir = @opts[:dir]
	end

  if @opts[:start]
    run_command([])
  end

  fsevent = FSEvent.new 
  fsevent.watch dir, { :latency => @opts[:throttle], :no_defer => true } do |directories|
    run_command(directories)
  end
  
  fsevent.run
end

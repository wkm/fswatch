require 'fswatch/version'

require 'rb-fsevent'
require 'term/ansicolor'

include Term::ANSIColor

module FSWatch
  
  fsevent = FSEvent.new
  fsevent.watch Dir.pwd do |directories|
    print red, "\n\n--- Changed: ", bold, blue, directories.inspect, reset, "\n"
    system(ARGV.join(' '))
  end
  
  fsevent.run
end

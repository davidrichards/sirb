# Called after sirb.rb, when we want to have stored procedures.  Sproc/
# Proc is pretty draconian, so I want to pull this out for now until
# more tests have been done. Probably we'll never want the command runner
# if Sirb is being used as a library, instead of as a real Irb instance.

Loader.add_lib('command runner') {
  require 'sirb/sproc'
  require 'sirb/runner'
  include Sirb::CommandLineMethods
}

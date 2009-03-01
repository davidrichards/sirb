# This is an adaptation from Florian Groß's submission to Ruby Quiz #38.
# http://rubyquiz.com/quiz38.html
# 
# I needed a serializable Proc, I don't care about the closure of
# the proc.  I just need to be able to store procs between Sirb sessions.  
# I'm using these procs with explicitly-passed context anyway, so they
# are meant to be portable functions. 

# Loads everything in Sproc, want to break this up, make it more useful
# and understandable. 
Dir.glob("#{File.dirname(__FILE__)}/sproc/*.rb").each { |file| require file }

require 'yaml'
YAML.add_ruby_type(/^proc/) do |type, val|
  Proc.from_string(val["source"])
end

EVAL_LINES__ = Hash.new

alias :old_eval :eval
def eval(code, *args)
  context, descriptor, start_line, *more = *args
  descriptor ||= "(eval#{code.hash})"
  start_line ||= 0
  lines ||= code.grep(/.*/)
  EVAL_LINES__[descriptor] ||= Array.new
  EVAL_LINES__[descriptor][start_line, lines.length] = lines
  old_eval(code, context, descriptor, start_line, *more)
end

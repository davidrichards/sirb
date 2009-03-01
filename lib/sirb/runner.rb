# So, this is interesting.  It's a class to store operations from blocks,
# and run them. 

# Persistent Store from Standard Library
require 'pstore'

module Sirb #:nodoc:
  
  class Runner
    class << self
      
      # Storing everything in local .pstore for now.  Uses the home directory,when possible.
      def pstore
        File.mkdir_p(dirname)
        @@pstore ||= PStore.new(filename)
      end
      protected :pstore
      
      def dirname
        @@dirname ||= File.expand_path(File.join(ENV['HOME'], '.sirb'))
      end
      protected :dirname
      
      def filename
        @@filename ||= File.join(dirname, "proc.pstore")
      end
      protected :filename
      
      # Needs a lambda, instead of a block, because we're serializing this and
      # the code I use to serialize this needs to be able to find the string
      # that created this code. 
      def add_command(name, l, description=nil)
        coerce name
        pstore.transaction { pstore[@name] = new(name.to_s, l, description) }
      end
      
      def remove_command(name)
        coerce name
        pstore.transaction { pstore.delete(@name) }
      end
      
      # Very harsh, but necessary if you have an unknown issue with a stored block.
      def reset_commands
        puts "Are you sure you want to remove all commands?(yN)\nThis will delete the contents of #{filename}"
        result = gets.strip
        return false unless result == 'y'
        `rm -rf #{filename}`
        puts "Successfully reset all commands."
      end
      
      def commands
        pstore.transaction { pstore.roots }
      end
      
      def commands_as_commands
        commands.map {|cmd| find(cmd)}
      end
      protected :commands_as_commands
    
      def find(name)
        return nil unless name
        coerce name
        begin
          pstore.transaction { pstore[@name] }
        rescue Exception => e
          # Don't know a good way to look in the pstore for something that doesn't
          # exist 
          nil
        end
      end
      
      def methodize(name)
        eval stringify_proc(name)
      end
      
      def stringify_proc(name)
        cmd = find(name)
        cmd_name = cmd.name
        matched = cmd.block_source.match(/^(\|.+\|)(.+)$/)
        cmd_params = matched ? matched[1] : ''
        cmd_body = matched ? matched[2] : nil
        cmd_body ||= cmd.block_source
        cmd_body.lstrip!
        "def #{cmd_name}(#{cmd_params})\n#{cmd_body}"
      end
      
      def run(name, *data)
        coerce name
        raise ArgumentError, "Unknown command: #{name}" unless self.find(@name)
        self.find(@name).run(*data)
      end
      
      def coerce(name)
        @name = name.to_sym
      end
      protected :coerce
      
      def sirb_help(command=nil)
        return puts(command_help(command)) if command
        puts(sirb_description, all_commands_description, '')
      end
      
      def sirb_description
        
        result = left_justify %{
          This is Irb, with some extra libraries and commands loaded.
          You have loaded the following libraries:
        }
        result += tab_indent( LibLoader.libs_loaded.join("\n") )
        result += "\n\n"
        
        if not LibLoader.failed_libs.empty?
          result += "The following libraries are not available on your system at this time:\n"
          result += tab_indent( LibLoader.failed_libs.join("\n") )
          result += "\n\n"
        end
                
        result
      end

      def all_commands_description
        result = ''
        
        if commands.empty?
          result += "You have not stored any custom commands at this time.\n\n"
        else
          result += "You have setup the following commands:\n\n"
          result += commands_as_commands.map{ |cmd| cmd.command_help }.join("\n")
          result += "\n\n"
        end
        
        result += "You can store a command like this:\n"
        result += tab_indent(%{
          set :command_name, lambda{|list params| command }, "Optional description"
        })

        result
        
      end
      protected :all_commands_description
      
      def command_help(command)
        cmd = find(command)
        cmd ? cmd.command_help : "Could not find the command: #{command}"
      end
      protected :command_help
      
      # Probably need to setup some decorators here instead...
      def tab_indent(str)
        return "" unless str
        str.strip.split("\n").map {|line| "\t#{line.strip}" }.join("\n")
      end
      
      def left_justify(str)
        return "" unless str
        str.split("\n").map {|line| line.lstrip }.join("\n")
      end
      
    end

    attr_reader :name, :description
    # Needs a lambda, instead of a block, because we're serializing this and
    # the code I use to serialize this needs to be able to find the string
    # that created this code. 
    def initialize(name, l, description=nil)
      @name, @block, @description = name, l, description
    end
  
    # Kind of loose: allows me to use reduce, map, or just call a stored
    # command.  This may just seem to work, but we'll see. 
    def run(*data)
      case @block.arity 
      when 2
        # Same as reduce
        data.inject &@block
      when 1
        # Same as map
        data.map &@block
      when -1
        # Same as call
        @block.call
      else
        # Probably not going to work.
        data.inject &@block
      end
    end
    
    def command_help
      result = (self.description and not self.description.empty?) ? formatted_description : empty_description
      result  + source_description
    end
    
    def arity_desc
      case @block.arity
      when -1
        "takes 0 arguments"
      when 1
        "takes 1 argument, returns an array"
      when 2
        "takes 2 arguments, returns a single value--reduce function"
      else
        "takes #{@block.arity} arguments"
      end
    end
    protected :arity_desc

    def block_source
      @block.source
    end
    
    def name_line
      "* #{self.name} (#{arity_desc})\n"
    end
    protected :name_line
    
    def source_description
      "\n\tSource: #{block_source}"
    end
    
    def empty_description
      "#{name_line}\tThere is no other information available for the #{self.name.to_s} command."
    end
    protected :empty_description
    
    def formatted_description
      name_line + 
      Runner.tab_indent(self.description)
    end
    protected :formatted_description
    
  end  
  
  # These should be available in the console generally
  module CommandLineMethods
    
    def store_command(name, l, description=nil)
      cmd = Runner.add_command(name, l, description)
      cmd.name.to_s + " added"
    end
    alias set store_command
    
    
    # May want to move this to delegate (standard library)
    # http://www.ruby-doc.org/stdlib/libdoc/delegate/rdoc/index.html
    def method_missing(sym, *args, &block)
      # base, extension = breakdown_method(sym)
      # if Runner.find(base) and extension == 'methodize'
      #   Runner.methodize(base)
      # elsif Runner.find(base) and extension == 'to_s'
      #   require 'rubygems'
      #   require 'ruby-debug'
      #   debugger
      #   Runner.stringify_proc(base)
      if Runner.find(sym)
        Runner.run(sym, *args)
      # elsif Runner.respond_to?(sym)
      elsif Runner.respond_to?(sym)
        Runner.send(sym, *args, &block)
      else
        super
      end
    end
    
    # Doesn't work.
    def breakdown_method(sym)
      s = sym.to_s
      r = /^(.+)\.(.+)$/
      md = s.match r
      md ? [md[1].to_sym, md[2]] : [nil,nil]
    end
    protected :breakdown_method
  end
  
end 

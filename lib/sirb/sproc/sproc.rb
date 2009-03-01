class Sproc < Proc

  class << self
    # An alternate constructor for the class, to allow string input.
    def build(arg=nil, &block)
      block_given? ? infer_sproc(block) : infer_sproc(arg)
    end
  
    def infer_sproc(arg)
      case arg
      when Proc
        Proc.new(&arg)
      when String
        Sproc.from_string(arg)
      else
        raise ArgumentError, "Don't know how to create a sproc from #{arg.inspect}"
      end
    end
    protected :infer_sproc
  end
  
  def source_descriptor
    if md = /^#<Proc:0x[0-9A-Fa-f]+@(.+):(\d+)>$/.match(old_inspect)
      filename, line = md.captures
      return filename, line.to_i
    end
  end

  attr_accessor :source
  def source
    ProcSource.handle(self) unless @source
    @source
  end

  alias :old_inspect :inspect
  def inspect
    if source
      "sproc {#{source}}"
    else
      old_inspect
    end
  end

  def ==(other)
    if self.source and other.source
      self.source == other.source
    else
      self.object_id == other.object_id
    end
  end

  def _dump(depth = 0)
    if source
      source
    else
      raise(TypeError, "Can't serialize Proc with unknown source code.")
    end
  end

  def to_yaml(*args)
    self.source # force @source to be set
    super.sub("object:Proc", "sproc")
  end

  def self.allocate; from_string ""; end

  def self.from_string(string)
    result = eval("Sproc.new {#{string}}")
    result.source = string
    return result
  end

  def self._load(code)
    self.from_string(code)
  end

  def self.marshal_load; end
  def marshal_load; end
end

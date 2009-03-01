class Proc
  def to_sproc
    Sproc.new(&self)
  end
end
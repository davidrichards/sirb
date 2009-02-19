class Loader
  class << self
    def libs
      @libs ||= {}
    end

    def add_lib(name, &block)
      name = name.to_s
      block ||= lambda{require name}
      self.libs[name] = self.safe_require(&block)
    end
    
    def all_libs
      self.libs.keys.sort
    end
    
    def libs_loaded
      self.libs.map {|k, v| k if v }.compact
    end
    
    def failed_libs
      self.libs.map {|k, v| k unless v }.compact
    end
    
    def safe_require(&block)
      begin
        block.call
        # If the lib is already loaded, it may return false, but it's available.
        # If there's a problem with this, you should require the lib in a block
        # and raise an exception if it fails. 
        true
        # If the laod returns false, then 
      rescue Exception => e # Very important
        false
      end
    end
    
    def to_s
      "Libs loaded:\n\t" + (self.libs_loaded.empty? ? "None" : self.libs_loaded.join(", ")) + 
      "\nLibs NOT loaded:\n\t" + (self.failed_libs.empty? ? "None" : self.failed_libs.join(", "))
    end
  end
  
end

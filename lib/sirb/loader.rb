class Loader
  class << self
    def add_lib(name, &block)
      @@lib ||= {}
      block ||= lambda{require name}
      @@lib[name] = self.safe_require(&block)
    end
    
    def libs_loaded
      @@lib.map {|k, v| k if v }.compact
    end
    
    def failed_libs
      @@lib.map {|k, v| k unless v }.compact
    end
    
    def safe_require(&block)
      begin
        block.call
        true
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

class File
  # From setup.rb.  Since I only need one method, I've added it here
  # instead of using the whole setup.rb lib. 
  def self.mkdir_p(dirname, prefix = nil)
    dirname = prefix + File.expand_path(dirname) if prefix
    # Does not check '/', it's too abnormal.
    dirs = File.expand_path(dirname).split(%r<(?=/)>)
    if /\A[a-z]:\z/i =~ dirs[0]
      disk = dirs.shift
      dirs[0] = disk + dirs[0]
    end
    dirs.each_index do |idx|
      path = dirs[0..idx].join('')
      Dir.mkdir path unless File.directory?(path)
    end
  end
end

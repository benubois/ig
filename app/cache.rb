class Cache
  def self.fetch(key, options = {}, &block)
    new(key, options, block).send(:cache)
  end

  private

  def initialize(key, options, block)
    @key = key
    @options = options
    @block = block
  end

  def cache(&block)
    cached? ? read : write(@block.call)
  end

  def cached?
    age < @options.fetch(:ttl, Time.now.to_i)
  rescue Errno::ENOENT
    false
  end

  def age
    Time.now.to_i - File.stat(cache_file).mtime.to_i
  end

  def read
    File.read(cache_file)
  end

  def write(value)
    File.write(cache_file, value)
    value
  end

  def cache_file
    @cache_file ||= File.join(Dir.tmpdir, Digest::SHA1.hexdigest(@key))
  end
end

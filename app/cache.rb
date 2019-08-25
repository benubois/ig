class Cache
  def self.fetch(key, &block)
    new(key, block).send(:cache)
  end

  private

  def initialize(key, block)
    @key = key
    @block = block
  end

  def cache(&block)
    cached? ? read : write(@block.call)
  end

  def cached?
    File.file?(cache_file)
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

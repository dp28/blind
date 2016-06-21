require_relative './error/invalid_directory_error'

class SourceDirectory
  attr_reader :path

  def initialize(path)
    @path = path
    validate
  end

  def files
    @files ||= Dir[File.join(path, '/*')].select { |file| File.file? file }
  end

  private

  def validate
    raise Error::InvalidDirectoryError, path if Dir[path].empty?
  end
end

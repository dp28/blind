require_relative './error/invalid_directory_error'
require_relative './blind'

class SourceDirectory
  attr_reader :path

  def initialize(path)
    @path = path
    validate
  end

  def files
    @files ||= Dir[File.join(path, '/*')].select(&method(:blindable_file?))
  end

  private

  def blindable_file?(file)
    File.file?(file) && file !~ %r{#{Blind::BLIND_FILE}$}
  end

  def validate
    raise Error::InvalidDirectoryError, path if Dir[path].empty?
  end
end

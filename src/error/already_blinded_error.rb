require_relative './blind_error'

module Error
  class AlreadyBlindedError < BlindError
    attr_reader :path

    def initialize(directory)
      super
      @path = directory.path
    end

    def message
      "'#{path}' has already been blinded"
    end
  end
end

# frozen_string_literal: true

module MegastoreOps
  class TaggedLogger
    def initialize(io=$stdout)
      @logger = ::Logger.new(io)
      @tags = []
    end

    def tag(tag)
      @tags << tag
      yield self
    ensure
      @tags.pop
    end

    def info(msg);  @logger.info(prefix + msg); end
    def warn(msg);  @logger.warn(prefix + msg); end
    def error(msg); @logger.error(prefix + msg); end
    def debug(msg); @logger.debug(prefix + msg); end

    private
    def prefix
      return '' if @tags.empty?
      "[#{@tags.join('][')}] "
    end
  end
end

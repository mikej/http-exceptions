require "http/exceptions/version"
require "http/exceptions/http_exception"

module Http
  module Exceptions
    EXCEPTIONS = [
      SocketError,
      Errno::ETIMEDOUT,
      Net::ReadTimeout,
      Net::OpenTimeout,
      Net::ProtocolError,
      Errno::ECONNREFUSED,
      Errno::EHOSTDOWN,
      Errno::ECONNRESET,
      OpenSSL::SSL::SSLError,
      EOFError,
    ].freeze

    def self.wrap_exception
      begin
        yield
      rescue *Exceptions::EXCEPTIONS => e
        raise HttpException.new original_exception: e
      end
    end

    def self.check_response!(res)
      raise HttpException.new(response: res) unless (200...300).include?(res.code)
      res
    end

    def self.wrap_and_check
      wrap_exception do
        check_response! yield
      end
    end
  end
end

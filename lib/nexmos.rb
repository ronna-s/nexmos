require 'logger'
require 'active_support/core_ext/hash'
require 'faraday'
require 'faraday_middleware'
require 'nexmos/version'
require 'nexmos/base'
module Nexmos
  extend self
  attr_accessor :api_key, :api_secret, :debug
  attr_writer :user_agent, :logger

  # ensures the setup only gets run once
  @_ran_once = false

  def reset!
    @logger = nil
    @_ran_once = false
    @user_agent = nil
    @api_key = nil
    @api_secret = nil
  end

  def user_agent
    @user_agent ||= "Nexmos v#{::Nexmos::VERSION}"
  end

  def setup
    yield self unless @_ran_once
    @_ran_once = true
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def apis
    @apis ||= YAML.load_file(File.expand_path('api.yml', File.dirname(__FILE__)))
  end

  reset!
end

require 'nexmos/railties' if defined?(::Rails)
require 'nexmos/account'
require 'nexmos/message'
require 'nexmos/number'
require 'nexmos/search'
require 'nexmos/text_to_speech'

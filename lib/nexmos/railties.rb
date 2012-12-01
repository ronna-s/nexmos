module Nexmos
  class Railties < ::Rails::Railtie
    initializer 'Rails logger' do
      ::Nexmos.logger = Rails.logger
    end
  end
end
require 'spec_helper'
describe ::Nexmos do
  subject{ ::Nexmos }

  before(:each) do
    subject.reset!
  end

  context '#reset!' do
    its(:user_agent) { should == "Nexmos v#{::Nexmos::VERSION}" }
    its(:api_key) { should be_nil }
    its(:api_secret) { should be_nil }
    its(:logger) { should be_kind_of(::Logger) }
  end

  context '#setup' do

    context 'single call' do
      it 'should set user_agent' do
        subject.setup do |c|
          c.user_agent = 'Test1245'
        end
        subject.user_agent.should == 'Test1245'
      end

      it 'should set logger' do
        newlogger = ::Logger.new(STDERR)
        subject.setup do |c|
          c.logger = newlogger
        end
        subject.logger.should == newlogger
      end

      it 'should set api_key' do
        subject.setup do |c|
          c.api_key = 'test-api-key'
        end
        subject.api_key.should == 'test-api-key'
      end

      it 'should set api_secret' do
        subject.setup do |c|
          c.api_secret = 'test-api-secret'
        end
        subject.api_secret.should == 'test-api-secret'
      end

    end

    context 'double call' do
      it 'should not accept running setup more then once' do
        subject.setup do |c|
          c.api_key = 'test-api-key'
        end
        subject.setup do |c|
          c.api_key = 'test-api-key2'
        end
        subject.api_key.should == 'test-api-key'
      end
    end
  end

end
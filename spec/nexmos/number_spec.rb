require 'spec_helper'
describe ::Nexmos::Number do
  let(:webmock_default_headers) do
    {
        :headers => {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => ::Nexmos.user_agent
        }
    }
  end

  let(:finland_numbers_search) do
    {"numbers" => [
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950816",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950815",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950814",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950813",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950812",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950806",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950805",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950804",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950798",
       "country" => "FI",
       "cost" => "3.00"},
      {"type" => "mobile-lvn",
       "msisdn" => "3584573950796",
       "country" => "FI",
       "cost" => "3.00"}],
     "count" => 22}
  end

  before(:each) do
    ::Nexmos.reset!
    ::Nexmos.setup do |c|
      c.api_key = 'default_key'
      c.api_secret = 'default_secret'
    end
  end

  subject { ::Nexmos::Number.new }

  context '#search' do
    it 'should return error on missed param' do
      expect { subject.search }.to raise_error('country params required')
    end

    it 'should return list of numbers' do
      request = stub_request(:get, "https://rest.nexmo.com/number/search?api_key=default_key&api_secret=default_secret&country=FI").
          with(webmock_default_headers).to_return(:status => 200, :body => finland_numbers_search, :headers => {})
      res = subject.search(:country => 'FI')
      res.should be_kind_of(::Hash)
      res.success?.should be_true
      res['count'].should == 22
      res['numbers'].should be_kind_of(::Array)
      res['numbers'].size.should == 10
      res['numbers'].first.keys.sort.should == ["cost", "country", "msisdn", "type"]
      request.should have_been_made.once
    end
  end

  context '#buy' do
    it 'should return error on missed params' do
      expect { subject.buy }.to raise_error('country,msisdn params required')
    end
    it 'should return error on missed params' do
      expect { subject.buy :country => 'FI' }.to raise_error('msisdn params required')
    end

    it 'should buy number' do
      request = stub_request(:post, "https://rest.nexmo.com/number/buy").
        with(
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=> ::Nexmos.user_agent},
          :body => {"api_key"=>"default_key", "api_secret"=>"default_secret", "country"=>"FI", "msisdn"=>"3584573950816"}
        ).to_return(:status => 200, :body => "", :headers => {})
      res = subject.buy(:country => 'FI', :msisdn => '3584573950816' )
      res.should be_kind_of(::Hash)
      res.success?.should be_true
      request.should have_been_made.once
    end

  end

  context '#cancel' do

  end

end

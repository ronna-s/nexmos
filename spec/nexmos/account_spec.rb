require 'spec_helper'
describe ::Nexmos::Account do
  let(:webmock_default_headers) do
    {
        :headers => {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => ::Nexmos.user_agent
        }
    }
  end

  let(:finland_prices) do
    {
        "mt" => "0.02500000",
        "country" => "FI",
        "prefix" => "358",
        "networks" =>
            [{"code" => "24491",
              "network" => "sonera, TeleFinland",
              "ranges" => ["35840", "35842", "358450"],
              "mtPrice" => "0.04500000"},
             {"code" => "24414",
              "network" => "GSM Aland",
              "ranges" => ["3584570", "3584573", "3584575"],
              "mtPrice" => "0.00850000"},
             {"code" => "24421",
              "network" => "SAUNALAHTI, EUnet Finland",
              "ranges" => ["358451", "358452", "358453", "358456", "358458"],
              "mtPrice" => "0.05000000"},
             {"code" => "24412",
              "network" => "dna",
              "ranges" =>
                  ["35841",
                   "35844",
                   "3584574",
                   "3584576",
                   "3584577",
                   "3584578",
                   "3584579",
                   "3584944"],
              "mtPrice" => "0.00850000"},
             {"code" => "24405",
              "network" => "elisa",
              "ranges" => ["35846", "35850"],
              "mtPrice" => "0.05000000"}],
        "name" => "Finland"
    }
  end

  let(:prefix_prices) do
    {"count" => 1,
     "prices" =>
       [{"mt" => "0.02500000",
         "country" => "FI",
         "prefix" => "358",
         "networks" =>
           [{"code" => "24491",
             "network" => "sonera, TeleFinland",
             "ranges" => nil,
             "mt_price" => "0.04500000"},
            {"code" => "24414",
             "network" => "GSM Aland",
             "ranges" => nil,
             "mtPrice" => "0.00850000"},
            {"code" => "24400",
             "network" => "Unknown Finland",
             "ranges" => nil,
             "mtPrice" => "0.02500000"},
            {"code" => "24421",
             "network" => "SAUNALAHTI, EUnet Finland",
             "ranges" => nil,
             "mtPrice" => "0.05000000"},
            {"code" => "24412",
             "network" => "dna",
             "ranges" => nil,
             "mtPrice" => "0.00850000"},
            {"code" => "24405",
             "network" => "elisa",
             "ranges" => nil,
             "mtPrice" => "0.05000000"}],
         "name" => "Finland"}],
     }
  end

  before(:each) do
    ::Nexmos.reset!
    ::Nexmos.setup do |c|
      c.api_key = 'default_key'
      c.api_secret = 'default_secret'
    end
  end

  subject { ::Nexmos::Account.new }

  context '#get_balance' do

    it 'should return value' do
      request = stub_request(:get, "https://rest.nexmo.com/account/get-balance?api_key=default_key&api_secret=default_secret").
          with(webmock_default_headers).to_return(:status => 200, :body => {"value" => 4.107}, :headers => {})
      res = subject.get_balance
      res.should be_kind_of(::Hash)
      res.value.should == 4.107
      request.should have_been_made.once
    end
  end

  context '#get_pricing' do
    it 'should return error on missed param' do
      expect { subject.get_pricing }.to raise_error('country params required')
    end

    it 'should be success' do
      request = stub_request(:get, "https://rest.nexmo.com/account/get-pricing/outbound?api_key=default_key&api_secret=default_secret&country=FI").
          with(webmock_default_headers).to_return(:status => 200, :body => finland_prices, :headers => {})
      res = subject.get_pricing(:country => 'FI')
      res.should be_kind_of(::Hash)
      res.success?.should be_true
      res.country.should == 'FI'
      res.keys.sort.should == %w(country name prefix mt networks success?).sort
      res.networks.should be_kind_of(::Array)
      res.networks[0].keys.sort.should == %w(code network mt_price ranges).sort
      request.should have_been_made.once
    end
  end

  context '#get_prefix_pricing' do
    it 'should return error on missed param' do
      expect { subject.get_prefix_pricing }.to raise_error('prefix params required')
    end

    it 'should be success' do
      request = stub_request(:get, "https://rest.nexmo.com/account/get-prefix-pricing/outbound?api_key=default_key&api_secret=default_secret&prefix=358").
          with(webmock_default_headers).to_return(:status => 200, :body => prefix_prices, :headers => {})
      res = subject.get_prefix_pricing(:prefix => '358')
      res.should be_kind_of(::Hash)
      res.success?.should be_true
      res.keys.sort.should == %w(count prices success?).sort
      res.prices.should be_kind_of(::Array)
      res.prices[0].keys.sort.should == %w(country name prefix mt networks).sort
      res.prices[0].networks.should be_kind_of(::Array)
      res.prices[0].networks[0].keys.sort.should == %w(code network mt_price ranges).sort
      request.should have_been_made.once
    end
  end

end

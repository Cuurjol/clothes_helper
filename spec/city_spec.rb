require 'rspec'
require 'tzinfo'
require 'net/http'
require 'rexml/document'
require_relative '../lib/city'

describe City do
  let(:local_time) { TZInfo::Timezone.get('Europe/Berlin').now }

  describe '#new' do
    it 'assigns instance variables' do
      allow_any_instance_of(City).to receive(:temperature).and_return(20.0)
      allow_any_instance_of(City).to receive(:local_time).and_return(local_time)
      city = City.new(7)
      expect(city.temperature).to eq 20.0
      expect(city.local_time).to eq local_time
    end
  end
end
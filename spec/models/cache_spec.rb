require 'rails_helper'

describe 'Cache' do
  let(:device_id) { '1' }
  let(:readings) {
    [{
       "timestamp": "2021-09-29T16:08:15+01:00",
       "count": 2
     },
     {
       "timestamp": "2021-09-29T16:09:15+01:00",
       "count": 15
     }]
  }

  describe 'add_readings' do
    # TODO: these tests aren't great as they rely on being run sequentially and also rely on the `find!` method. I
    # would change that with more time to make them independent of each other and verify the expected behavior in a
    # different way
    it 'stores a new device in the cache' do
      Cache.instance.add_readings(device_id, readings)
      expect(Cache.instance.find!(device_id).nil?).to eq(false)
      expect(Cache.instance.find!(device_id).readings.size).to eq(2)
    end

    it 'adds readings to an existing device' do
      additional_readings = [{
                               "timestamp": "2021-09-29T16:11:15+01:00",
                               "count": 2
                             },
                             {
                               "timestamp": "2021-09-29T16:12:15+01:00",
                               "count": 15
                             }]
      Cache.instance.add_readings(device_id, additional_readings)
      expect(Cache.instance.find!(device_id).nil?).to eq(false)
      expect(Cache.instance.find!(device_id).readings.size).to eq(4)
    end
  end

  describe 'find!' do
    let(:device_id) { '2' }

    it 'retrieves an existing device' do
      Cache.instance.add_readings(device_id, readings)
      expect(Cache.instance.find!(device_id).nil?).to eq(false)
      expect(Cache.instance.find!(device_id).is_a?(Device)).to eq(true)
      expect(Cache.instance.find!(device_id).readings.size).to eq(2)
    end

    it 'raises an error when the device is not found' do
      Cache.instance.add_readings(device_id, readings)
      expect{ Cache.instance.find!('none') }.to raise_error(Cache::NotFound)
    end
  end
end

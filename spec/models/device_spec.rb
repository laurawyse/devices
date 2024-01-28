require 'rails_helper'

describe 'Device' do
  let(:id) { '36d5658a-6908-479e-887e-a949ec199272' }
  let(:readings) {
    [{
       timestamp: '2021-09-29T16:08:15+01:00',
       count: 2
     },
     {
       timestamp: '2021-09-29T16:09:15+01:00',
       count: 15
     }
    ]
  }
  let(:device) { Device.new(id, readings) }

  describe 'initialize' do
    it 'sets id' do
      expect(device.id).to eq(id)
    end

    it 'initializes and sets readings' do
      expect(device.readings.length).to eq(readings.length)
      expect(device.readings[0].is_a?(Reading)).to eq(true)
      expect(device.readings[0].timestamp).to eq(readings[0][:timestamp])
      expect(device.readings[0].count).to eq(readings[0][:count])
      expect(device.readings[1].is_a?(Reading)).to eq(true)
      expect(device.readings[1].timestamp).to eq(readings[1][:timestamp])
      expect(device.readings[1].count).to eq(readings[1][:count])
    end

    describe 'with no readings' do
      let(:readings) { [] }

      it 'sets id' do
        expect(device.id).to eq(id)
      end

      it 'initializes and sets readings' do
        expect(device.readings).to eq([])
      end
    end
    describe 'with duplicate readings' do
      let(:readings) {
        [{
           timestamp: '2021-09-29T16:08:15+01:00',
           count: 2
         },
         {
           timestamp: '2021-09-29T16:08:15+01:00',
           count: 10
         },
         {
           timestamp: '2021-09-29T16:09:15+01:00',
           count: 15
         }
        ]
      }

      it 'ignores duplicate reading' do
        expect(device.readings.length).to eq(2)
        expect(device.readings[0].is_a?(Reading)).to eq(true)
        expect(device.readings[0].timestamp).to eq(readings[0][:timestamp])
        expect(device.readings[0].count).to eq(readings[0][:count])
        expect(device.readings[1].is_a?(Reading)).to eq(true)
        expect(device.readings[1].timestamp).to eq(readings[2][:timestamp])
        expect(device.readings[1].count).to eq(readings[2][:count])
      end
    end
  end

  describe 'latest_timestamp' do
    describe 'when readings are in order' do
      it 'returns timestamp from latest reading' do
        expect(device.latest_timestamp).to eq('2021-09-29T16:09:15+01:00')
      end
    end

    describe 'when readings are out of order' do
      let(:readings) {
        [{
           timestamp: '2021-10-29T16:08:15+01:00',
           count: 2
         },
         {
           timestamp: '2021-09-29T16:09:15+01:00',
           count: 15
         }
        ]
      }

      it 'returns timestamp from latest reading' do
        expect(device.latest_timestamp).to eq('2021-10-29T16:08:15+01:00')
      end
    end

    describe 'when readings are empty' do
      let(:readings) { [] }

      it 'returns nil' do
        expect(device.latest_timestamp).to be_nil
      end
    end
  end

  describe 'cumulative_count' do
    it 'returns total count from readings' do
      expect(device.cumulative_count).to eq(17)
    end

    describe 'when readings are empty' do
      let(:readings) { [] }

      it 'returns 0' do
        expect(device.cumulative_count).to eq(0)
      end
    end
  end

  describe 'add_readings' do
    describe 'with a duplicate reading' do
      let(:additional_readings) {
        [{
           timestamp: '2021-09-29T16:08:15+01:00',
           count: 2
         },
         {
           timestamp: '2021-09-29T16:10:15+01:00',
           count: 3
         }
        ]
      }

      it 'ignores duplicate reading; adds new reading' do
        device.add_readings(additional_readings)
        expect(device.readings.length).to eq(3)
        expect(device.readings[0].is_a?(Reading)).to eq(true)
        expect(device.readings[0].timestamp).to eq(readings[0][:timestamp])
        expect(device.readings[0].count).to eq(readings[0][:count])
        expect(device.readings[1].is_a?(Reading)).to eq(true)
        expect(device.readings[1].timestamp).to eq(readings[1][:timestamp])
        expect(device.readings[1].count).to eq(readings[1][:count])
        expect(device.readings[2].is_a?(Reading)).to eq(true)
        expect(device.readings[2].timestamp).to eq(additional_readings[1][:timestamp])
        expect(device.readings[2].count).to eq(additional_readings[1][:count])
      end
    end
  end
end

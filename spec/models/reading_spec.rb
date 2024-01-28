require 'rails_helper'

describe 'Reading' do
  let(:timestamp) { '2021-09-29T16:08:15+01:00' }
  let(:count) { 2 }
  let(:reading) { Reading.new(timestamp, count) }

  describe 'initialize' do
    it 'sets timestamp' do
      expect(reading.timestamp).to eq(timestamp)
    end

    it 'sets count' do
      expect(reading.count).to eq(count)
    end
  end
end

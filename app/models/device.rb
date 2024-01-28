class Device
  attr_accessor :id, :readings

  # TODO: add validations & docs
  def initialize(id, readings)
    @id = id
    # readings should be unique per timestamps; ignore any duplicates
    unique_readings = readings.uniq { |r| r[:timestamp] }
    @readings = unique_readings.map { |r| Reading.new(r[:timestamp], r[:count]) }
  end

  # TODO: could also sort on insert if this operation is read heavy and then just grab the last reading
  def latest_timestamp
    @readings.sort_by(&:timestamp).last&.timestamp
  end

  # TODO: could also store and update this on insert if this operation is read heavy and we have a large number of readings
  def cumulative_count
    @readings.reduce(0) { |cumulative_count, r| cumulative_count + r.count.to_i }
  end

  # TODO: this function is pretty ugly and I would likely use a different data structure where I can use the
  # timestamp as a unique key more easily.
  def add_readings(additional_readings)
    additional_readings.each do |additional_reading|
      unless @readings.any? { |existing_reading| existing_reading.timestamp == additional_reading[:timestamp] }
        @readings << Reading.new(additional_reading[:timestamp], additional_reading[:count])
      end
    end
  end
end
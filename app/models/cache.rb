class Cache
  class NotFound < StandardError; end

  include Singleton

  def initialize
    @cache = {}
  end

  def find!(id)
    value = @cache[id]
    raise NotFound if value.nil?
    value
  end

  def add_readings(device_id, readings)
    existing_device = @cache[device_id]

    if existing_device.nil?
      device = Device.new(device_id, readings)
      @cache[device_id] = device
    else
      existing_device.add_readings(readings)
    end
  end
end
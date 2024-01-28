class Reading
  attr_accessor :timestamp, :count

  # TODO: add validations & docs
  def initialize(timestamp, count)
    @timestamp = timestamp
    @count = count
  end
end
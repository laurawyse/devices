class DevicesController < ApplicationController
  # TODO:
  #   define params structure and types (especially readings)
  #   add serializers for responses

  def create_readings
    Cache.instance.add_readings(params.require(:id), params.require(:readings))

    render json: {
      id: params.require(:id)
    }
  end

  def latest_timestamp
    device = Cache.instance.find!(params.require(:id))

    render json: {
      latest_timestamp: device.latest_timestamp
    }
  end

  def cumulative_count
    device = Cache.instance.find!(params.require(:id))

    render json: {
      cumulative_count: device.cumulative_count
    }
  end
end

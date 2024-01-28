Rails.application.routes.draw do
  scope '/api/v1' do
    # health check
    get 'ping', to: 'application#ping'

    post 'readings', to: 'devices#create_readings'
    get 'devices/:id/latest_timestamp', to: 'devices#latest_timestamp'
    get 'devices/:id/cumulative_count', to: 'devices#cumulative_count'
  end
end

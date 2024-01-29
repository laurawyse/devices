require 'rails_helper'

describe DevicesController do
  let(:device_id) { '36d5658a-6908-479e-887e-a949ec199272' }
  let(:params) {
    {
      "id": device_id,
      "readings": [{
                     "timestamp": "2021-09-29T16:08:15+01:00",
                     "count": 2
                   },
                   {
                     "timestamp": "2021-09-29T16:09:15+01:00",
                     "count": 15
                   }
      ]
    }
  }

  describe 'create_readings' do
    it 'returns 200' do
      post :create_readings, params: params
      expect(response).to have_http_status(:success)
    end

    it 'returns the device id' do
      post :create_readings, params: params
      response_body = JSON.parse(response.body).deep_symbolize_keys
      expect(response_body[:id]).to eq(device_id)
    end

    it 'stores readings in cache' do
      post :create_readings, params: params
      expect(Cache.instance.find!(device_id).id).to eq(device_id)
      expect(Cache.instance.find!(device_id).readings.length).to eq(2)
    end

    describe 'when making a second request with the same device id' do
      let(:params2) {
        {
          "id": device_id,
          "readings": [{
                         "timestamp": "2021-09-29T16:08:15+01:00",
                         "count": 2
                       }
          ]
        }
      }

      describe 'with unique readings' do
        let(:device_id) { '1115658a-6908-479e-887e-a949ec199272' }

        it 'adds new readings to the existing device in cache' do
          second_request_params = {
            "id": device_id,
            "readings": [{
                           "timestamp": "2021-09-29T16:10:15+01:00",
                           "count": 2
                         }
            ]
          }

          post :create_readings, params: params
          post :create_readings, params: second_request_params
          expect(response).to have_http_status(:success)
          expect(Cache.instance.find!(device_id).readings.length).to eq(3)
        end
      end

      describe 'with repeated readings' do
        let(:device_id) { '2225658a-6908-479e-887e-a949ec199272' }

        it 'ignores readings with repeated timestamps' do
          repeat_reading_params = {
            "id": device_id,
            "readings": [{
                           "timestamp": "2021-09-29T16:08:15+01:00",
                           "count": 2
                         }
            ]
          }

          post :create_readings, params: params
          post :create_readings, params: repeat_reading_params
          expect(response).to have_http_status(:success)
          expect(Cache.instance.find!(device_id).readings.length).to eq(2)
        end
      end
    end
  end

  describe 'latest_timestamp' do
    before do
      # TODO: instead of relying on another API call to do this, could just seed the cache to isolate testing
      post :create_readings, params: params
    end

    describe 'for existing device' do
      it 'returns 200' do
        get :latest_timestamp, params: { id: device_id }
        expect(response).to have_http_status(:success)
      end

      it 'returns the latest_timestamp' do
        get :latest_timestamp, params: { id: device_id }
        response_body = JSON.parse(response.body).deep_symbolize_keys
        expect(response_body[:latest_timestamp]).to eq('2021-09-29T16:09:15+01:00')
      end
    end

    describe 'for non-existing device' do
      it 'returns 404' do
        get :latest_timestamp, params: { id: 'bad_id' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'cumulative_count' do
    before do
      # TODO: instead of relying on another API call to do this, could just seed the cache to isolate testing
      post :create_readings, params: params
    end

    describe 'for existing device' do
      it 'returns 200' do
        get :cumulative_count, params: { id: device_id }
        expect(response).to have_http_status(:success)
      end

      it 'returns the cumulative_count' do
        get :cumulative_count, params: { id: device_id }
        response_body = JSON.parse(response.body).deep_symbolize_keys
        expect(response_body[:cumulative_count]).to eq(17)
      end
    end

    describe 'for non-existing device' do
      it 'returns 404' do
        get :cumulative_count, params: { id: 'bad_id' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

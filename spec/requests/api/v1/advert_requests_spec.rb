require 'rails_helper'

RSpec.describe "Adverts", type: :request do
  describe '#show' do
    context 'when advert is present' do
      let(:advert) { create(:advert) }
      it 'returns advert' do
        get api_v1_advert_path(advert.id)

        expect(JSON.parse(response.body)['id']).to eq(advert.id)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'when advert is not present' do
      it 'it returns an error' do
        get api_v1_advert_path(1)

        expect(JSON.parse(response.body)['error']).to eq('Record not found')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
  describe '#index' do
    context 'without filters with adverts' do
      before { FactoryBot.create_list(:advert, 3)}
      it 'returns 3 results' do
        get api_v1_adverts_path

        expect(JSON.parse(response.body).count).to eq(3)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'without filters without adverts' do
      it 'returns no results' do
        get api_v1_adverts_path

        expect(JSON.parse(response.body).count).to eq(0)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with after filter' do
      let!(:advert_older) { create(:advert, created_at: 1.month.ago) }
      let!(:advert_newer) { create(:advert) }

      it 'returns current ad' do
        get api_v1_adverts_path, params: { after: (Time.now - 2.weeks)}

        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body).first['id']).to eq(advert_newer.id)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with before filter' do
      let!(:advert_older) { create(:advert, created_at: 1.month.ago) }
      let!(:advert_newer) { create(:advert) }

      it 'returns current ad' do
        get api_v1_adverts_path, params: { before: (Time.now - 2.weeks)}

        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body).first['id']).to eq(advert_older.id)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with lower filter' do
      let!(:advert_cheap) { create(:advert, price: 50) }
      let!(:advert_costly) { create(:advert, price: 100) }

      it 'returns cheap ad' do
        get api_v1_adverts_path, params: { lower: 60}

        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body).first['id']).to eq(advert_cheap.id)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with greater filter' do
      let!(:advert_cheap) { create(:advert, price: 50) }
      let!(:advert_costly) { create(:advert, price: 100) }

      it 'returns pricy ad' do
        get api_v1_adverts_path, params: { greater: 60}

        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body).first['id']).to eq(advert_costly.id)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with page param' do
      before { FactoryBot.create_list(:advert, 26) }

      it 'returns page one' do
        get api_v1_adverts_path, params: { page: 1}

        expect(JSON.parse(response.body).count).to eq(25)
        expect(response.headers['X-Per-Page']).to eq('25')
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Total']).to eq('26')
        expect(response).to have_http_status(:ok)
      end

      it 'returns page two' do
        get api_v1_adverts_path, params: { page: 2}

        expect(JSON.parse(response.body).count).to eq(1)
        expect(response.headers['X-Per-Page']).to eq('25')
        expect(response.headers['X-Page']).to eq('2')
        expect(response.headers['X-Total']).to eq('26')
        expect(response).to have_http_status(:ok)
      end
    end
  end
  describe '#create' do
    context 'when params are valid' do
      let!(:correct_params) do
        {
          title: Faker::Vehicle.make_and_model,
          description: Faker::Vehicle.standard_specs.join,
          car_foto: fixture_file_upload(Rails.root.join('spec', 'support', 'assets', "car-#{rand(1..9)}.jpg"), 'image/jpg'),
          price: Faker::Number.decimal(l_digits: 2)
        }
      end

      it 'creates an ad' do
        expect { post api_v1_adverts_path, params: { advert: correct_params } }
          .to(change { Advert.all.count }.by(1))
        expect(response).to have_http_status(:ok)
      end
    end
    context 'when params are missing' do
      let!(:missing_params) do
        {
          car_foto: fixture_file_upload(Rails.root.join('spec', 'support', 'assets', "car-#{rand(1..9)}.jpg"), 'image/jpg'),
          price: Faker::Number.decimal(l_digits: 2)
        }
      end

      it 'creates an ad' do
        expect { post api_v1_adverts_path, params: { advert: missing_params } }
          .to_not(change { Advert.all.count })
        expect(JSON.parse(response.body)['errors']).to eq(["Description can't be blank", "Title can't be blank"])
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    context 'when foto has a wrong format' do
      let!(:correct_params) do
        {
          title: Faker::Vehicle.make_and_model,
          description: Faker::Vehicle.standard_specs.join,
          car_foto: fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'sample.pdf'), 'pdf'),
          price: Faker::Number.decimal(l_digits: 2)
        }
      end

      it 'creates an ad' do
        expect { post api_v1_adverts_path, params: { advert: correct_params } }
          .to_not(change { Advert.all.count })
        expect(JSON.parse(response.body)['errors']).to eq(['Picture attached is not in a supported format'])
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

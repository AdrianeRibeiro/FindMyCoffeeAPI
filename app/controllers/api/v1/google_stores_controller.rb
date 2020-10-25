class Api::V1::GoogleStoresController < ApplicationController
  def index
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    places = coffe_list
    render json: places
  end

  def show
    @google_place_id = params[:id]
    render json: coffe_details
  end

  def coffe_list
    key = google_secret_key
    location = "location=#{@latitude},#{@longitude}"
    radius = 'radius=5000'
    url = "#{base_url}/textsearch/json?query=coffee+shops&#{location}&#{radius}&#{key}"
    get_info_api(url)
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end

  def coffe_details
    key = google_secret_key
    url = "#{base_url}/details/json?place_id=#{@google_place_id}&#{key}"
    get_info_api(url)
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end

  def get_info_api(url)
    response = RestClient.get url
    JSON.parse(response.body)
  end

  def base_url
    'https://maps.googleapis.com/maps/api/place'
  end

  def google_secret_key
    "key=#{Rails.application.credentials.google_secret_key}"
  end
end

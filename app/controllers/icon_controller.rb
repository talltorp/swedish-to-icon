require 'rest-client'

class IconController < ApplicationController
  respond_to :json

  def list
    begin
      translation = translate_word_to_swedish

      # google translate

      render json: {s: translation}.to_json, status: :ok
    rescue => e
      p e
      return_unavailable_status
    end
  end

  private
  def word_to_translate
    params["word"]
  end

  def translate_word_to_swedish
    response = RestClient.get google_translate_url
    json = JSON.parse(response)
    json["data"]["translations"][0]["translatedText"]
  end

  def google_translate_url
    "https://www.googleapis.com/language/translate/v2?key=#{ENV['GOOGLE_TRANSLATE_KEY']}&q=#{CGI::escape(word_to_translate)}&source=sv&target=en"
  end

  def return_unavailable_status
    render nothing: true, status: :service_unavailable
  end
end
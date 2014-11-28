require 'rest-client'

class IconController < ApplicationController
  respond_to :json, :html

  def list
    begin
      @icons = list_of_icons_for swedish_word_translated_into_english

      respond_to do |format|
        format.html
        format.json { render json: @icons }
      end
    rescue => e
      p e
      return_unavailable_status
    end
  end

  private
  def swedish_word
    params["word"]
  end

  def swedish_word_translated_into_english
    response = RestClient.get google_translate_url
    json = JSON.parse(response)
    p json
    json["data"]["translations"][0]["translatedText"]
  end

  def google_translate_url
    "https://www.googleapis.com/language/translate/v2?key=#{ENV['GOOGLE_TRANSLATE_KEY']}&q=#{CGI::escape(swedish_word)}&source=sv&target=en"
  end

  def list_of_icons_for(english_word)
    NounProjectIcons.new.search_for(english_word)
  end

  def icon_search_url(english_word)
    "http://api.thenounproject.com/icons/#{english_word}"
  end

  def return_unavailable_status
    render nothing: true, status: :service_unavailable
  end
end
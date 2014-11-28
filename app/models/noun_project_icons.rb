require "oauth"

class NounProjectIcons
  def initialize
    @key = ENV['NOUN_PROJECT_KEY']
    @secret = ENV['NOUN_PROJECT_SECRET']
  end

  def search_for(english_word)
    consumer = OAuth::Consumer.new(@key, @secret)
    access_token = OAuth::AccessToken.new consumer

    response = access_token.get(icon_search_url(english_word))
    json = JSON.parse(response.body)
    list = []
    json["icons"].each do | icon |
      list << icon["preview_url"]
    end
    list
  end

  private

  def icon_search_url(english_word)
    "http://api.thenounproject.com/icons/#{english_word}"
  end
end
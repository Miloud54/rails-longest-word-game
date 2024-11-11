require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @wordletters = @word.chars
    @letters = params[:letters]
    begin
      found = JSON.parse(URI.open("https://dictionary.lewagon.com/#{@word}").read)["found"]
    rescue OpenURI::HTTPError => e
      Rails.logger.error "HTTP Error: #{e.message}"
      found = false
    end
    if @wordletters.all? { |letter| @letters.count(letter) >= @word.count(letter) }
      if found
        @message = "Congratulations! #{@word} is a valid English word!"
      else
        @message = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @message = "Sorry but #{@word} can't be built out of #{@letters}"
    end
  end
end

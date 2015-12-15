require 'Nokogiri'
require 'open-uri'

class NbaLogo
  # Document for main page
  def self.getDoc
    return Nokogiri::HTML(open('http://www.sportslogos.net/teams/list_by_league/6/National_Basketball_Association/NBA/logos/'))
  end


  def self.allSmall
    list = self.getDoc.css("#team .logoWall li a")
    logos = {}
    list.each do |x|
      logos[x.text.strip.chomp] = x.css('img').attr('src').text
    end
    return logos
  end
end

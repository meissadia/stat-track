module ApplicationHelper
  def teamLogoWeb(abbr)
    url = "http://a.espncdn.com/combiner/i?img=/i/teamlogos/nba/500/%s.png&h=150&w=150"
    abbr.downcase!
    case abbr
    when 'uta'
      abbr = 'utah'
    when 'nop'
      abbr = 'no'
    when 'pho'
      abbr = 'phx'
    end
    return url % [abbr]
  end

  def teamLogo(abbr)
    return asset_path "logos/#{abbr.upcase}.gif"
  end

  def teamCourt(abbr)
    return asset_path "courts/#{abbr.upcase}.gif"
  end

  def leagueLogoWeb
    return 'http://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/nba.png?w=150&h=150'
  end
end

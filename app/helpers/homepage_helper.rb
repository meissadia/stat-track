module HomepageHelper
  def seasonString(type)
    case type
    when 1
      return "Pre Season"
    when 2
      return "Regular Season"
    when 3
      return "Post Season"
    end
  end

  def current_season_type
    return Game.all.order('datetime desc').limit(1).pluck(:season_type).first
  end
end

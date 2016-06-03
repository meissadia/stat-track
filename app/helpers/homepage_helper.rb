module HomepageHelper
  def seasonString(type)
    case type
    when 1
      return "Preseason"
    when 2
      return "Regular"
    when 3
      return "Playoffs"
    end
  end
end

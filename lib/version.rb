# Version: Constant for current app version
# @example
# require 'lib/version'
# include Version
# puts VERSION #=> '0.0.1'
module Version
  # GEM version
  VERSION = '0.0.4'
end


########################### Current Version  ###################################

# 0.0.4
# @new
# 1. Add more functional (but ugly) landing page with Conference Standings
#    and Today's Games.
# 2. Add top performers (by GameScore) to View Game#show
# @fixed-issues
# 1. View Game#show | Correct sorting of FG/FT/3P now

########################### Version History ####################################

# 0.0.3
# @fixed-issues
# 1. Game.UpdateFromSchedule now correctly updates Gamestat info for
#    games that have already been completed!

# 0.0.2
# @fixed-issues
# 1. Game.UpdateFromSchedule now correctly updates Game info for
#    games that have already been completed!

# 0.0.1
# @fixed-issues
# 1. Player#show MIL
#    Expected: Johnny O'Bryant III
#    Actual: Johnny OBryant IIIBryant III
#    Check escaping of ' from EspnReader
#    Solution: EspnReader was at fault. Install updated version.
#      Gemfile:: EspnReader 0.0.1

# 0.0.0
# @known-issues
# 1. Fix Game.UpdateDb (not updating) x
# @future-features
# 1. Switch Database to MySQL
# 2. Port Team Summary
# 3. Implement Queries

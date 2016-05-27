# Version: Constant for current app version
# @example
# require 'lib/version'
# include Version
# puts VERSION #=> '0.0.1'
module Version
  # GEM version
  VERSION = '0.0.6'
end


########################### Current Version  ###################################
# 0.0.6
# @fixed-issues
# 1. New version of EspnScrape to correctly pull data
# 2. Tons of re-writes and fixes to get system back to functional

########################### Version History ####################################
# 0.0.5
# @new
# 1. TEAM LOGOS!
# 2. Team's Top 5
# 3. Team Court Images
# 4. Lots of other UI improvements

# 0.0.4
# @new
# 1. Add more functional (but ugly) landing page with Conference Standings
#    and Today's Games.
# 2. Add top performers (by GameScore) to View Game#show
# 3. Add GameScore to Gamestats shown in Player#show and Game#show
# 4. Add Top Performances to Homepage#index
# 5. Improve nav menus look and feel
# 6. Add a bunch of Gamestat SQL formulas
# 7. Add "Last Updated" in MaintainDB#index and MaintainDB#updateDb
# 8. Add games.js with code to fix display of Top Performer
# @fixed-issues
# 1. View Game#show | Correct sorting of FG/FT/3P now
# 2. Stop overwriting Gamestats.gdate in Game.UpdateFromSchedule
# 3. MaintainDB#index display corrections
# 4. Correct sorting of Dates

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

# Version: Constant for current app version
# @example
# require 'lib/version'
# include Version
# puts VERSION #=> '0.0.1'
module Version
  # GEM version
  VERSION = '0.0.2'
end


########################### Current Version  ###################################
# 0.0.2
# @fixed-issues
# 1. Game.UpdateFromSchedule now correctly updates Game/Gamestat info for
#    games that have already been completed!  No more need to reseed the entire
#    database to bring it up-to-date.

########################### Version History ####################################

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
# 1. Fix Game.UpdateDb (not updating)
# @future-features
# 1. Switch Database to MySQL
# 2. Port Team Summary
# 3. Implement Queries

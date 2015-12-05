# Version: Constant for current app version
# @example
# require 'lib/version'
# include Version
# puts VERSION #=> '0.0.1'
module Version
  # GEM version
  VERSION = '0.0.1'
end


########################### Current Version  ###################################
# 0.0.1
# @fixed-issues
# 1. Player#show MIL
#    Expected: Johnny O'Bryant III
#    Actual: Johnny OBryant IIIBryant III
#    Check escaping of ' from EspnReader
#    Solution: EspnReader was at fault. Install updated version.
#      Gemfile:: EspnReader 0.0.1
# 2. Game.UpdateFromSchedule (TEST)

########################### Version History ####################################

# 0.0.0
# @known-issues
# 1. Fix Game.UpdateDb (not updating)
# @future-features
# 1. Switch Database to MySQL
# 2. Port Team Summary
# 3. Implement Queries

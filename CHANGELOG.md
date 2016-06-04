## Change Log :: StatTrack

## 0.0.14
###new
+ Implemented CHANGELOG.md

## 0.0.13
###new
+ Include populated Development database, to avoid long initial setup times
+ Added configuration options for db:seed in db/seeds_config.rb
+ Revamped README and converted to Markdown
+ Added seeds_stored.rb for faster database resets (set seeds_config -> @useStoredData = true)

###changed
+ Cleaned up Routes file

## 0.0.12
+ Homepage improvements

## 0.0.11
###new
+ EspnScrape 0.1.1
+ Include Preseason and Playoff data

###changed
+ Homepage layout improvements
  * Added some partials

## 0.0.10
###new
+ Add rake server:stop to kill background server
  * Specify port: rake server:stop port=4000

## 0.0.9
###new
+ Added boot configuration to bind server ip to local machine ip,  
making the instance reachable from other devices on the local network.

###fixed-issues
+ Fixed Top Players display issue where table data was overflowing when the  
viewport was small.

## 0.0.8
+ Integrated new version of EspnScrape

## 0.0.7
###fixed-issues
+ Games.updateFromSchedule fixed

## 0.0.6
###fixed-issues
+ New version of EspnScrape to correctly pull data
+ Tons of re-writes and fixes to get system back to functional

## 0.0.5
###new
+ TEAM LOGOS!
+ Team's Top 5
+ Team Court Images
+ Lots of other UI improvements

## 0.0.4
###new
+ Add more functional (but ugly) landing page with Conference Standings and Today's Games.
+ Add top performers (by GameScore) to View Game#show
+ Add GameScore to Gamestats shown in Player#show and Game#show
+ Add Top Performances to Homepage#index
+ Improve nav menus look and feel
+ Add a bunch of Gamestat SQL formulas
+ Add "Last Updated" in MaintainDB#index and MaintainDB#updateDb
+ Add games.js with code to fix display of Top Performer  

###fixed-issues
+ View Game#show | Correct sorting of FG/FT/3P now
+ Stop overwriting Gamestats.gdate in Game.updateFromSchedule
+ MaintainDB#index display corrections
+ Correct sorting of Dates

## 0.0.3
### fixed-issues
+ Game.updateFromSchedule now correctly updates Gamestat info for games that have already been completed!

## 0.0.2
###fixed-issues
+ Game.updateFromSchedule now correctly updates Game info for games that have already been completed!

## 0.0.1
###fixed-issues
+ Handling Player Names with apostrophes
 * Issue was in EspnReader.
 * Updated to EspnReader 0.0.1

## 0.0.0
###known-issues
+ Fix Game.UpdateDb (not updating)

###future-features
+ Switch Database to MySQL
+ Port Team Summary
+ Implement Queries

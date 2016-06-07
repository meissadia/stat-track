## Change Log :: StatTrack

## 0.0.15
####&nbsp;&nbsp;&nbsp;changed
+ EspnScrape 0.3.0
+ New formatting in CHANGELOG

## 0.0.14
####&nbsp;&nbsp;&nbsp;new
+ Implemented CHANGELOG.md

## 0.0.13
####&nbsp;&nbsp;&nbsp;new
+ Include populated Development database, to avoid long initial setup times
+ Added configuration options for db:seed in db/seeds_config.rb
+ Revamped README and converted to Markdown
+ Added seeds_stored.rb for faster database resets (set seeds_config -> @useStoredData = true)

####&nbsp;&nbsp;&nbsp;changed
+ Cleaned up Routes file

## 0.0.12
+ Homepage improvements

## 0.0.11
####&nbsp;&nbsp;&nbsp;new
+ EspnScrape 0.1.1
+ Include Preseason and Playoff data

####&nbsp;&nbsp;&nbsp;changed
+ Homepage layout improvements
  * Added some partials

## 0.0.10
####&nbsp;&nbsp;&nbsp;new
+ Add rake server:stop to kill background server
  * Specify port: rake server:stop port=4000

## 0.0.9
####&nbsp;&nbsp;&nbsp;new
+ Added boot configuration to bind server ip to local machine ip,  
making the instance reachable from other devices on the local network.

####&nbsp;&nbsp;&nbsp;fixed-issues
+ Fixed Top Players display issue where table data was overflowing when the  
viewport was small.

## 0.0.8
+ Integrated new version of EspnScrape

## 0.0.7
####&nbsp;&nbsp;&nbsp;fixed-issues
+ Games.updateFromSchedule fixed

## 0.0.6
####&nbsp;&nbsp;&nbsp;fixed-issues
+ New version of EspnScrape to correctly pull data
+ Tons of re-writes and fixes to get system back to functional

## 0.0.5
####&nbsp;&nbsp;&nbsp;new
+ TEAM LOGOS!
+ Team's Top 5
+ Team Court Images
+ Lots of other UI improvements

## 0.0.4
####&nbsp;&nbsp;&nbsp;new
+ Add more functional (but ugly) landing page with Conference Standings and Today's Games.
+ Add top performers (by GameScore) to View Game#show
+ Add GameScore to Gamestats shown in Player#show and Game#show
+ Add Top Performances to Homepage#index
+ Improve nav menus look and feel
+ Add a bunch of Gamestat SQL formulas
+ Add "Last Updated" in MaintainDB#index and MaintainDB#updateDb
+ Add games.js with code to fix display of Top Performer  

####&nbsp;&nbsp;&nbsp;fixed-issues
+ View Game#show | Correct sorting of FG/FT/3P now
+ Stop overwriting Gamestats.gdate in Game.updateFromSchedule
+ MaintainDB#index display corrections
+ Correct sorting of Dates

## 0.0.3
####&nbsp;&nbsp;&nbsp; fixed-issues
+ Game.updateFromSchedule now correctly updates Gamestat info for games that have already been completed!

## 0.0.2
####&nbsp;&nbsp;&nbsp;fixed-issues
+ Game.updateFromSchedule now correctly updates Game info for games that have already been completed!

## 0.0.1
####&nbsp;&nbsp;&nbsp;fixed-issues
+ Handling Player Names with apostrophes
 * Issue was in EspnReader.
 * Updated to EspnReader 0.0.1

## 0.0.0
####&nbsp;&nbsp;&nbsp;known-issues
+ Fix Game.UpdateDb (not updating)

####&nbsp;&nbsp;&nbsp;future-features
+ Switch Database to MySQL
+ Port Team Summary
+ Implement Queries

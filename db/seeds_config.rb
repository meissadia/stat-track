require 'benchmark'
require 'espnscrape'
##
## Configuration for database Seeding :: db:seed or db:setup
##
SEASON_TYPES = [1,2,3] # => Restrict season types: 1-Preseason, 2-Regular, 3-Playoff

# => Determine data source
# false - Read data from internet (Slower but up-to-date)
# true  - Use included seed data file (Faster but limited to included data. You can always update any missing data from the 'DB' page of the running app  )
USE_STORED_DATA = false

# => Overwrite seed data file
# If you modify the database schema, the stored seed data will be obsolete.
# This option will save the new Create commands.
# By default, you cannot overwrite the file you are seeding from (!USE_STORED_DATA)
# Change the second half of the || vvvvv to your desired behavior
SAVE_TO_FILE = !USE_STORED_DATA || false
STORED_SEEDS = "seeds_stored.rb"

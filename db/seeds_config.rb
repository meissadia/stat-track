##
## Configuration for database Seeding :: db:seed or db:setup
##
@seasonTypes = [1,2,3] # => Restrict season types: 1-Preseason, 2-Regular, 3-Playoff

# => Determine data source
# false - Read data from internet (Slower but up-to-date)
# true  - Use included seed data file (Faster but limited to included data. You can always update any missing data from the 'DB' page of the running app  )
@useStoredData = false

# => Overwrite seed data file
# If you modify the database schema, the stored seed data will be obsolete. This option will save the new Create commands.
@overwriteStoredData = true
@fileName = "seeds_stored.rb"

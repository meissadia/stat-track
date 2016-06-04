## StatTrack

### Introduction
StatTrack allows you to customize your own sports stats tracking site. Modify the controllers/views to select/display the information you want to see!  *`Currently only for NBA`*

###QUICK START  
The Development database is already populated with the latest data available at the time of it's commit, so you can dive right into exploring the application.  From your StatTrack directory:
```
> bundle install
> rails server
```

In your web browser, navigate to http://localhost:3000

*To update any newly available data, access the '[DB](http://localhost:3000/maintain_db)' page within the running application.*

###Database creation
`Not required if using the included Development database`  
If you modify the database schema, deploy to a non-Development environment, or just want to start fresh:
```
> rake db:migrate
> rake db:setup
```
*A full seasons worth of data takes approx. 20 mins to populate.*

###Configuring seeds.rb
There are a few options if you want to restrict what data is pulled into the database. These settings can be found in the 'db/seeds_config.rb' file.    
######*seasonTypes*  
Restrict data to your preferred season types:  
```
# 1-Preseason, 2-Regular, 3-Playoff  
@seasonTypes = [1,2,3]
```

######*useStoredData*  
When seeding, you can pull the most up-to-date data from the internet or use an included dataset to reset the database:  
```
# false - internet data, true - local dataset  
@useStoredData = false
```

###Requirements
#####Ruby/Rails version
*Built on Ruby 2.2.3p173 / Rails 4.2.5*

###Dependencies
*espnscrape 0.1.1  
jquery-tablesorter*

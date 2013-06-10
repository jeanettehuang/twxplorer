# twXplorer

twXplorer is a tool that improves upon the current Twitter search. Searching for a topic on Twitter returns a page of noisy results with no clear indication as to what the trending tweets for a topic are, making it difficult for a user to find exactly what he is looking for. Our tool addresses the shortcomings of the existing Twitter search functionality by enabling users to drill-down and explore deeper within their results. 

Features include:
* View a list of tweets matching given a search term
* View a bar chart of word counts of individual terms from tweets
* Drill-down into search results by clicking on bar chart
* Exclude words from results
* View previous search snapshots to see if topics have changed over time
* Export results to a CSV file 

## Installation and Usage
* Install Ruby on Rails `http://rubyonrails.org/download`
* Install PostgreSQL `http://www.postgresql.org/` or `http://postgresapp.com/`
* Clone this repository 
* Run `bundle install`
* Run `rake db:create` followed by `rake db:migrate` to setup the database tables
* Generate a Twitter API key and Oauth by creating a developer account on Twitter, include this information in `/lib/tasks/initsetup.rake`

## Starting the App
* In your console, navigate to where you cloned the repo and run `rails s`
* Open your favorite browser and go to this address `http://localhost:3000/`

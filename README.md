dreamLog
========

DreamLog is a simple message board for dreams. It is built with backbone.js together with handlebar.js for creating template. 
All backbone views and models are located in <code>assests/javascripts</code> directory.

Checkout a live [demo here](http://dreamlog.heroku.com).

####assets/javascript/views:

There are seven backbone class:

 * homePage.js.coffee : 
    
 * dreamLog.js.coffee :    
    
 * leftBar.js.coffee :   

 * newDreamLog.js.coffee:

 * filter.js.coffee: 
       
 * commentView.js.coffee:

 * replyView.js.coffee:

    
    
    
####assets/javascript/models:

models.js.coffee contains all backbone models and collections

__collections__:
 * users                 
 * logs                     
 * comments             
 * replies      
 * votes           
 

####Fetching all collections before loading page content:

        $.when(
            App.usersCollection.fetch(),
            App.currentUser.fetch(),
            App.dreams.fetch(),
            App.comments.fetch(),
            App.replies.fetch(),
            App.votes.fetch()
        ).then ->
            # setup page and load page content


####Setting up backbone collection with rails backend

Here is an example on Logs collection:

__routes.rb:__

    resources :log
    
__model.js.coffee:__
    
    # Log model 
    class Log extends Backbone.Model
        paramRoot: 'log'              # set up root parameter
        url:->
            if @id
                return "log/#{@id}"   # --> GET, DELETE, PUT
            else
                return "log"          # --> POST/CREATE

        initialize:(option)->
        
    # Logs collection
    class Logs extends Backbone.Collection
        model:Log
        url:'log'



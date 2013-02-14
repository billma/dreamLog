#=================
#
#   Models, Collections
#
#***************************


#       User Model 

class App.User extends Backbone.Model
  url:()->
    return "users/"+@id
  initialize:(option)->
    @id=option['id']
    return @
 
#       Current User 

class App.CurrentUser extends Backbone.Model
  url:'current'
  initialize:->
    return @

#      Users Collection

class App.Users extends Backbone.Collection
  model:App.User
  url:'users'

  initialize:->
  getThumb:(id)->
    return @.get(id).get 'thumb_url'
  getName:(id)->
    return @.get(id).get 'name'

 #     Log Model

class App.Log extends Backbone.Model
  paramRoot: 'log'
  url:->
    if @id
      return "log/#{@id}"
    else
      return "log"

  initialize:(option)->

#     Logs Collection 

class App.Logs extends Backbone.Collection
  model:App.Log
  url:'log'


#------Comment model ---------------

class App.Comment extends Backbone.Model
  paramRoot:'comment'
  url:->
    if @id
      return "comment/#{@id}"
    else
      return "comment"

  initialize:(option)->
 
#------Comments Collection ---------------

class App.Comments extends Backbone.Collection
  model:App.Comment
  url:'comment'
  initialize:->

  getLogComments:(log_id)->
    return @.where {log_id:log_id}


#------Reply model ---------------

class App.Reply extends Backbone.Model
  paramRoot: 'reply'
  url:->
    if @id
      return "reply/#{@id}"
    else
      return "reply"
  initialize:->

#------Replies collection ---------------

class App.Replies extends Backbone.Collection
  model:App.Reply
  url:'reply'

  initialize:->
  getCommentReplies:(id)->
    return @.where {comment_id:id}

#------Vote Model ---------------

class App.Vote extends Backbone.Model
  paramRoot: 'vote'
  url:->
    if @id
      # DELETE 
      return "vote/#{@id}"
    else
      # POST
      return "vote"

  initialize:(option)->
    self=@
    @.bind 'remove', ->
      self.destroy()

	
#------Votes collection ---------------
class App.Votes extends Backbone.Collection
  model:App.Vote
  url:'vote'

  initialize:->
  getVotes:(log_id)->
    userVote=false
    r=@.where {log_id:log_id}
    d=@.where {
      log_id:log_id
      user_id:App.currentUser.get('id')
    }
    if d.length>0
      userVote=true
    return {
      count:r.length
      userVote: userVote
    }



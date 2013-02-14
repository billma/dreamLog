# -----------------------------------
#
#           DreamLog 
#
# ===================================
# Show Log model content, comments, replies 
# and votes
# call load() to load Log model content
class App.DreamLog extends Backbone.View
  el:'#dreamLog'

  events:
    'click .dreamLog_closeButton':'close'
    'click #read':'showRead'
    'click #comments':'showComments'
    'keyup #addComment':'addComment'
    'click #vote':'voteHandler'
  
  # constructor
  initialize:->
    @template=$('#dreamLog-template').generateTemplate()



  # ---------------
  # public methods

  # load content into dreamLog Viewer 
  load:(log)->
    self=@
    # set to current log model
    @log=log

    data=log.toJSON()
    data.cuser_icon=App.currentUser.get 'thumb_url'

    # sync time with dreamLog flash
    setTimeout( ->
      $(self.el).html self.template(data)
      self.updateVotes()
      #load comments 
      logComments= App.comments.getLogComments(log.get('id'))
      _.each logComments, (comment)->
         new App.CommentView {model:comment}
    ,500)

   
  #open dream log
  open:->
    if @isOpen()
      @flash()
    else
      $(@el).removeClass 'dreamLog_closed'

  # close dream log
  close:->
    if !App.editMode
      @clearActive()
    $(@el).addClass 'dreamLog_closed'

  # flash dream log 
  flash:->
     $(@el).flashDiv()

  # return true if already open
  isOpen:->
    if $(@el).hasClass 'dreamLog_closed' then return false else return true

  clearActive:->
     #clear previous active li
    $('.showDreamArrow').removeClass 'showDreamArrow'
    $('.dreamActive').removeClass 'dreamActive'
    $('.showProfileImg').removeClass 'showProfileImg'
    $('.dreamDateFades').removeClass 'dreamDateFades'


  # --------------- 
  # private methods 
  
  # show log body on  click 'read'
  showRead:=>
    $('.comment-wrap').removeClass 'showComments'
    $('.dream_content').addClass 'showRead'

  # show comments and replies on click 'comments' 
  showComments:=>
    $('.comment-wrap').addClass 'showComments'
    $('.dream_content').removeClass 'showRead'
  
  # add comment on enter
  addComment:(e)=>
    if e.keyCode is 13
      # clear line break
      body=$('#addComment').val().replace(/(\r\n|\n|\r)/gm,"")
      data={
        body:body
        log_id:@log.id
      }

      # create new comment and display commentView
      App.comments.create data, {
        success:(c)->
          new App.CommentView {model:c}
      }
      $('#addComment').val('')

  # create or delete vote
  voteHandler:=>
    data={
      log_id:@log.get('id') ,
      user_id:App.currentUser.get 'id'
    }
    vote=App.votes.where data
    console.log App.currentUser
    if vote.length>0
      App.votes.remove vote[0]
    else
      App.votes.create data

    @updateVotes()

  
  heartEmpty:=>
      $('#vote i').removeClass 'icon-heart'
      $('#vote i').addClass 'icon-heart-empty'
  heartFull:=>
      $('#vote i').removeClass 'icon-heart-empty'
      $('#vote i').addClass 'icon-heart'

  updateVotes:=>
    n= App.votes.getVotes @log.get 'id'
    $('#voteCount').html n['count']
    # update log model with the new vote couts
    @log.set {vote_counts:n['count']}
    if n['userVote'] then @heartFull() else @heartEmpty()

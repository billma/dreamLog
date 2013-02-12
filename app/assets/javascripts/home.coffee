
#=================
#
#   Models, Collections
#
#***************************


#       User Model 

class User extends Backbone.Model
  url:()->
    return "users/"+@id
  initialize:(option)->
    @id=option['id']
    return @
 
#       Current User 

class CurrentUser extends Backbone.Model
  url:'current'
  initialize:->
    return @

#      Users Collection

class Users extends Backbone.Collection
  model:User
  url:'users'

  initialize:->
  getThumb:(id)->
    return @.get(id).get 'thumb_url'
  getName:(id)->
    return @.get(id).get 'name'
  hasVoted:(log_id)->
    if votes.where {log_id:log_id, user_id:@.get('id')}
      return true
    else
      return false
#     Log Model

class Log extends Backbone.Model
  paramRoot: 'log'
  url:->
    if @id
      return "log/#{@id}"
    else
      return "log"

  initialize:(option)->

#     Logs Collection 

class Logs extends Backbone.Collection
  model:Log
  url:'log'


#------Comment model ---------------

class Comment extends Backbone.Model
  initialize:(option)->
  create:(data)->
    self=@
    $.post 'comment/create', data, (r)->
      self.set r
      self.trigger 'newCommentCreated'

#------Comments Collection ---------------

class Comments extends Backbone.Collection
  model:Comment
  url:'comments'
  initialize:->

  getLogComments:(log_id)->
    return @.where {log_id:log_id}


#------Reply model ---------------

class Reply extends Backbone.Model
  initialize:->
  create:(data)->
    self=@
    $.post 'reply/create', data, (r)->
      self.set r
      self.trigger 'newReplyCreated'

#------Replies collection ---------------

class Replies extends Backbone.Collection
  model:Reply
  url:'replies'

  initialize:->
  getCommentReplies:(id)->
    return @.where {comment_id:id}

#------Vote Model ---------------

class Vote extends Backbone.Model
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


class Votes extends Backbone.Collection
  model:Vote
  url:'vote'

  initialize:->
  getVotes:(log_id)->
    userVote=false
    r=@.where {log_id:log_id}
    d=@.where {
      log_id:log_id
      user_id:currentUser.get('id')
    }
    if d.length>0
      userVote=true
    return {
      count:r.length
      userVote: userVote
    }


#=================
#
# Setup Variables 
#
#************************


# setup global variables
dreamLog=popup=filter=leftBar=newDreamLog=logList=''
editMode=false
#setup collections and data
currentUser=new CurrentUser()
usersCollection= new Users()
dreams= new Logs()
comments=new Comments()
replies=new Replies()
votes=new Votes()
usersCollection.fetch()


# =================
#
#     Backbone Views 
#
# **********************************
# ---------------------------------  
#
#           HomePage
#
# =================================
class HomePage extends Backbone.View
  el:$('body')
  events:
    'click .add_icon':'openForm'
    'click .edit_icon':'activateEditMode'
    'click .exit_edit':'exitEditMode'
  initialize:->
    @initPage()

  #----------------
  # private methods

  # initialize page objects
  initPage: =>
    # when replies are loaded
    # create DreamLog
    replies.on 'reset', ->
      dreamLog=new DreamLog()
      
    #create leftBar
    leftBar=new LeftBar()
    #create log list
    logList=new LogListView()
    #create filter object
    filter=new Filter()
      
    newDreamLog=new NewDreamLog()
   
    
  openForm:=>
    dreamLog.close()
    newDreamLog.clearForm()
    newDreamLog.open()


  activateEditMode:=>

    editMode=true
    dreamLog.clearActive()
    newDreamLog.clearForm()
    newDreamLog.activateEditMode()
    filter.userFilter()
    filter.hide()
    dreamLog.close()
    $('.exit_edit, .edit_icon, .add_icon').toggle()
    $('.profileImg, .delete_icon').toggle()
    $('.dream').addClass 'dream_editMode'
    $('.profileImg-wrap').addClass 'showProfileImg'
    $('.dreamDate').addClass 'dreamDateFades'

  exitEditMode:=>
    editMode=false
    newDreamLog.close()
    newDreamLog.clearActive()
    newDreamLog.clearForm()
    newDreamLog.exitEditMode()
    filter.noFilter()
    filter.show()
    $('.profileImg, .delete_icon').toggle()
    $('.exit_edit, .edit_icon, .add_icon').toggle()
    $('.dream').removeClass 'dream_editMode'
    $('.profileImg-wrap').removeClass 'showProfileImg'
    $('.dreamDate').removeClass 'dreamDateFades'




# ---------------------------------    
#
#            LeftBar 
#
# =================================       
class LeftBar extends Backbone.View
  el:$('body')
  events:
    'click #l_icon':'toggleSidebar'

  initialize:->

  toggleSidebar:->
     if $('.left').hasClass 'left_close'
       $('.left').removeClass 'left_close'
       $('.right').removeClass 'right_expand'
       $('.add_icon, .edit_icon, .exit_edit').addClass 'icon_show'
     else
       $('.left').addClass 'left_close'
       $('.right').addClass 'right_expand'
       $('.add_icon, .edit_icon, .exit_edit').removeClass 'icon_show'
# ---------------------------------    
#
#            Filter 
#
# =================================   
class Filter extends Backbone.View
  el:$('body')
  events:
    'click #filter':'togglePopup'
    'click .popup-option':'close'
    'click #userFilter':'userFilter'
    'click #noFilter':'noFilter'
    'keyup #search':'searchTitle'
  initialize:->
    @mode="noFilter"
    self=@
    $(window).click (e)->
      if e.target.id isnt "filter"
         self.close()
  open:->
    $('.popup').addClass 'popup_open'

  close:->
    $('.popup').removeClass 'popup_open'
  hide:->
    $('#filter').hide()
  show:->
    $('#filter').show()
  passiveClose:(e)=>

  togglePopup:->
    if $('.popup').hasClass 'popup_open'
       @close()
    else 
       @open()
  noFilter:->
    @mode="noFilter"
    $('.dream').show()
  userFilter:->
    @mode="userFilter"
    $('.dream').show()
    $('.dream[user_id!="'+currentUser.get('id')+'"]').hide()
  searchTitle:(e)=>
    
    v=$('#search').val().toLowerCase().replace(/\s+/g, '')
    if v == ''
      if @mode is "noFilter"
        @noFilter()
      
      if @mode is "userFilter" or editMode
        @userFilter()
      
    else
      $('.dream').hide()
      $(".dream[title*=#{v}]").show()

    

# -----------------------------------
#
#           DreamLog 
#
# ===================================
# object for displaying a dream log
# must call load() first 
class DreamLog extends Backbone.View

  template:$('#dreamLog-template').generateTemplate()

  el:$('#dreamLog')

  events:
    'click .dreamLog_closeButton':'close'
    'click #read':'showRead'
    'click #comments':'showComments'
    'keyup #addComment':'addComment'
    'click #vote':'vote'

  initialize:->
        self=@
  
  # --------------- 
  # private methods 
  
  # show article on  click 'read'
  showRead:=>
    $('.comment-wrap').removeClass 'showComments'
    $('.dream_content').addClass 'showRead'

  # show comments on click 'comments' 
  showComments:=>
    $('.comment-wrap').addClass 'showComments'
    $('.dream_content').removeClass 'showRead'

  addComment:(e)=>
    if e.keyCode is 13
      body=$('#addComment').val().replace(/(\r\n|\n|\r)/gm,"")
      data={
        body:body
        log_id:@log.id
      }
      c=new Comment()
      c.create data
      @.listenTo c, 'newCommentCreated', ->
        comments.push c
        new CommentView {model:c}
      $('#addComment').val('')
  vote:=>
    data={
      log_id:@log.get('id') ,
      user_id:currentUser.get 'id'
    }
    vote=votes.where data
    self=@
    if vote.length>0
      votes.remove vote[0]
      @updateVotes()
    else
      votes.create data
      @updateVotes()

  heartEmpty:=>
      $('#vote i').removeClass 'icon-heart'
      $('#vote i').addClass 'icon-heart-empty'
  heartFull:=>
      $('#vote i').removeClass 'icon-heart-empty'
      $('#vote i').addClass 'icon-heart'

  updateVotes:=>
    n= votes.getVotes @log.get 'id'
    $('#voteCount').html n['count']
    @log.set {vote_counts:n['count']}
    if n['userVote']
      @heartFull()
    else
      @heartEmpty()

   # ---------------
   # public methods

  # load content into dreamLog Viewer 
  load:(log)->
    self=@
    @log=log
    #load reading content
    data=log.toJSON()
    data.cuser_icon=currentUser.get 'thumb_url'

    # sync time with dreamLog flash
    setTimeout( ->
      $(self.el).html self.template(data)
      self.updateVotes()
      #load comments 
      logComments= comments.getLogComments(log.get('id'))
      _.each logComments, (comment)->
         new CommentView {model:comment}
    ,500)

   
  #open dream log
  open:->
    if @isOpen()
      @flash()
    else
      $(@el).removeClass 'dreamLog_closed'

  # close dream log
  close:->
    if !editMode
      @clearActive()
    $(@el).addClass 'dreamLog_closed'

  # flash dream log 
  flash:->
     self=@
     $(@el).css('opacity',0)
     setTimeout( ->
       $(self.el).css('opacity',1)
     ,500)

  # return true if already open
  isOpen:->
    if $(@el).hasClass 'dreamLog_closed'
      return false
    else
      return true

  clearActive:->
     #clear previous active li
    $('.showDreamArrow').removeClass 'showDreamArrow'
    $('.dreamActive').removeClass 'dreamActive'
    $('.showProfileImg').removeClass 'showProfileImg'
    $('.dreamDateFades').removeClass 'dreamDateFades'





#--------------------------------------        
# 
#             NewDreamLog
# 
#=====================================
# Form for creating a new dreamlog 
class NewDreamLog extends Backbone.View

  template:$('#newDream-template').generateTemplate()

  tagName:'div'

  id:'newDreamLog'

  events:
    'click #submit':'submit'
    'click .newDreamLog_closeButton':'close'

  initialize:->
    @render()

  render:->
    $(@el).html @template()
    $('#newDreamLog-wrap').html @el

  submit:->
    @ballEffect()
    if editMode
      @updateLog()
    else
      @addNewLog()

  open:->
    $('#newDreamLog-wrap').removeClass 'dreamLog_closed'

  load:(log)->
    @model=log
    $('#title').val log.get('title')
    $('#body').val log.get('body')

  close:->
    @bounceEffect()
    @clearActive()
    $('#newDreamLog-wrap').addClass 'dreamLog_closed'
  flash:->
    self=@
    $(@el).css('opacity',0)
    setTimeout( ->
      $(self.el).css('opacity',1)
    ,500)
  isOpen:->
    return !$('#newDreamLog-wrap').hasClass 'dreamLog_closed'

  activateEditMode:->
    @bounceEffect()
    $('#title, #body').css 'background', 'rgba(232, 44, 12, 0.1)'
    $('#submit').css 'background', 'rgba(255,72,13,0.1)'

  exitEditMode:->
    @bounceEffect()
    $('#title, #body').css 'background', 'rgba(57, 120, 172, 0.3)'
    $('#submit').css 'background', 'rgba(57, 120, 172, 0.3)'
    
  clearActive:->
    $('.dream').removeClass 'dreamActive_editMode'
  clearForm:->
    $('#title').val ''
    $('#body').val ''

  #---------------
  # private mehtod
  #
  ballEffect:=>
    @clearEffect()
    if editMode
      $('#submit-effect').addClass 'ball_editMode'
    else
      $('#submit-effect').addClass 'ball'

  bounceEffect:=>
    @clearEffect()
    if editMode
      $('#submit-effect').addClass 'bounceOut_editMode'
    else
      $('#submit-effect').addClass 'bounceOut'
  clearEffect:=>
    $('#submit-effect').removeClass 'bounceOut_editMode'
    $('#submit-effect').removeClass 'bounceOut'
    $('#submit-effect').removeClass 'ball'
    $('#submit-effect').removeClass 'ball_editMode'


  updateLog:=>
    self=@
    data={
      log_id:@model.get 'id'
      title:$('#title').val()
      body:$('#body').val()
    }
    @model.save data, success:->
      setTimeout( ->
        self.bounceEffect()
        self.close()
      ,1000)


  addNewLog:=>
    self=@
    data={
      title:$('#title').val()
      body:$('#body').val()
    }
    dreams.create data, success:(newLog)->
      setTimeout( ->
        self.bounceEffect()
        self.close()
        lv= new LogView {model:newLog}
        $('#dreamList').prepend lv.render()
        dreamLog.load(newLog)
        dreamLog.open()

      ,1000)

# ----------------------------------        
#
#             LogView: 
#
# ==================================
# list view for the left bar post list
class LogView extends Backbone.View

  template:$('#dream-template').generateTemplate()

  tagName:'li'

  className:'dream'

  events:
    'click .dreamInfo':'dreamHandler'
    'click .delete_icon':'deleteLog'

  initialize:->
    # find user icon by user id
    user_icon=usersCollection.get(@model.get('user_id')).get 'thumb_url'

    # create calender with timestamp
    @setupCalendar()

    # set user_icon
    @model.set {
      user_icon:user_icon
      vote_counts:votes.getVotes(@model.id)['count']
    }
    
    # listen for change and destroy event
    @.listenTo @model, 'change', @render
    @.listenTo @model, 'destroy', @destroy

  render:->
    # set attr for filtering and log searching
    $(@el).attr 'user_id',@model.get('user_id')
    $(@el).attr 'title', @model.get('title').toLowerCase().replace(/\s+/g, '')
    # load template with data 
    $(@el).html(@template(@model.toJSON()))
    if $(@el).hasClass 'dreamActive'
      @dreamActive()
    # dipslay in edit mode
    if editMode
      @.$('.profileImg, .delete_icon').toggle()
      @.$('.dream').addClass 'dream_editMode'
      @.$('.profileImg-wrap').addClass 'showProfileImg'
      @.$('.dreamDate').addClass 'dreamDateFades'

    return @el

  dreamHandler:->
    # edit mode
    if editMode
      dreamLog.close()
      newDreamLog.clearActive()
      newDreamLog.load(@model)
      $(@el).addClass 'dreamActive_editMode'
      if newDreamLog.isOpen()
        newDreamLog.flash()
      else
        newDreamLog.open()

    # show mode
    else
      newDreamLog.close()
      @dreamActive()
      dreamLog.load @model
      if dreamLog.isOpen()
        dreamLog.flash()
      else
        dreamLog.open()

  dreamActive:=>
    # clear previously active dreamLog
    dreamLog.clearActive()

    # activate current dreamLog
    @.$('.profileImg-wrap').addClass 'showProfileImg'
    @.$('.dreamDate').addClass 'dreamDateFades'
    @.$('.dreamArrow').addClass 'showDreamArrow'
    $(@el).addClass 'dreamActive'
 
  setupCalendar:=>
    month=[
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ]
    time= new Date @model.get 'created_at'
    
    @model.set {
      date:time.getDate()
      month:month[time.getMonth()]
      year:time.getFullYear()
    }

  deleteLog:=>
    @model.destroy()

  destroy:=>
    @remove()
      
# --------------------------------        
#
#          LogListView: 
#
# ================================
# list all the view the left bar 

class LogListView extends Backbone.View

  el:$('#dreamList')

  initialize:->
    self=@
    # render after all dreams are loaded
    dreams.on 'reset', ->
       votes.on 'reset', ->
          self.render()

  render:->
    dreams.each (data)->
      lv=new LogView({model:data})
      $('#dreamList').prepend lv.render()


# -------------------------------        
#
#         CommentView: 
#
# ===============================
# display each interpretation 

class CommentView extends Backbone.View

  template:$('#comment-template').generateTemplate()

  tagName:'li'

  className:'comment'

  events:
    'click .allCommentLink':'showReplies'
    'keyup .addReply':'addReply'
    
  initialize:->
    @render()

  render:->
    user_id= @model.get 'user_id'
    @model.set {
      user_icon:usersCollection.getThumb user_id
      user_name:usersCollection.getName user_id
      cuser_icon:currentUser.get 'thumb_url'
    }
    $(@el).html(@template(@model.toJSON()))
    @loadReplies()
    $('#comments-list').prepend @el
    @.$('.timeago').timeago()


  # private method 
  loadReplies:=>
    self=@
    replylist=replies.getCommentReplies @model.get 'id'
    if replylist.length>0
      @.$('.allCommentLink').hide()
      _.each replylist, (reply)->
        rv=new ReplyView {model:reply}
        self.$('.reply-list ul').append rv.render()
    else
      @.$('.reply-list').addClass 'reply-list-closed'


  showReplies:=>
    @toggleReplyList()
    @toggleCommentArrow()

  toggleReplyList:=>
    a=@.$('.reply-list')
    if a.hasClass 'reply-list-closed'
      a.removeClass 'reply-list-closed'
    else
      a.addClass 'reply-list-closed'

  toggleCommentArrow:=>
    a=@.$('.allCommentLink .icon-chevron-down')
    if a.hasClass 'icon-up'
      a.removeClass 'icon-up'
    else
      a.addClass 'icon-up'

  addReply:(e)=>
    self=@
    if e.keyCode is 13
      @.$('.allCommentLink').hide()
      body=@.$('.addReply').val().replace(/(\r\n|\n|\r)/gm,"")
      data={
        body:body
        comment_id:@model.get 'id'
      }
      r=new Reply()
      r.create data
      @.listenTo r, 'newReplyCreated', ->
        replies.push r
        rv= new ReplyView {model:r}
        self.$('.reply-list ul').append rv.render()
        $('.timeago').timeago()
      @.$('.addReply').val('')


# ------------------------------        
#
#          ReplyView: 
#
# ==============================
# display each reply 

class ReplyView extends Backbone.View
  template:$('#reply-template').generateTemplate()

  tagName:'li'

  className:'reply'

  initialize:->
  render:->
    @model.set {
      user_name:usersCollection.getName @model.get('user_id')
      user_icon:usersCollection.getThumb @model.get('user_id')
    }
    $(@el).html @template(@model.toJSON())
    return @el




#----page onload -----
#load all users
usersCollection.on 'reset', ->
  #load current User
  currentUser.fetch success:->
    dreams.fetch()
    comments.fetch()
    replies.fetch()
    votes.fetch()
    new HomePage()
    $('body').addClass('b-img')
    setTimeout  ->
      init()
    ,1500
    leftBar.toggleSidebar()
  

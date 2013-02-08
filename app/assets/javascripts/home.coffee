
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

#     Log Model

class Log extends Backbone.Model
  initialize:(option)->
  create:(data)->
    self=@
    $.post 'log/create', data, (r)->
      self.set r
      #create a new Logview
      new LogView({model:self})
      self.trigger 'newLogCreated'
       
#     Logs Collection 

class Logs extends Backbone.Collection
  model:Log
  url:'logs'


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


#=================
#
# Setup Variables 
#
#************************


# setup global variables
dreamLog=popup=filter=leftbar=newDreamLog=logList=''
editMode=false
#setup collections and data
currentUser=new CurrentUser()
usersCollection= new Users()
dreams= new Logs()
comments=new Comments()
replies=new Replies()
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
    'click .add_icon':'showNewDream'
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
      console.log replies
      dreamLog=new DreamLog()
      
    #create leftBar
    leftBar=new LeftBar()
    #create log list
    logList=new LogListView()
    #create filter object
    filter=new Filter()
      
    newDreamLog=new NewDreamLog()
    
  showNewDream:=>
    dreamLog.close()
    newDreamLog.open()

  activateEditMode:=>
    dreamLog.clearActive()
    filter.userFilter()
    filter.hide()
    editMode=true
    dreamLog.close()
    $('.profileImg, .delete_icon').toggle()
    $('.exit_edit, .edit_icon, .add_icon').toggle()
    $('.dream').addClass 'dream_editMode'
    $('.profileImg-wrap').addClass 'showProfileImg'
    $('.dreamDate').addClass 'dreamDateFades'

  exitEditMode:=>
    newDreamLog.close()
    newDreamLog.clearActive()
    filter.noFilter()
    filter.show()
    editMode=false
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

  toggleSidebar:=>
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


   # ---------------
   # public methods

  # load content into dreamLog Viewer 
  load:(log)->
    self=@
    @log=log
    #load reading content
    log.set {cuser_icon:currentUser.get 'thumb_url'}

    # sync time with dreamLog flash
    setTimeout( ->
      $(self.el).html self.template(log.toJSON())
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
    @addNewLog()

  open:->
    $('#newDreamLog-wrap').removeClass 'dreamLog_closed'

  close:->
    @bounceEffect()
    $('#newDreamLog-wrap').addClass 'dreamLog_closed'
  flash:->
    self=@
    $(@el).css('opacity',0)
    setTimeout( ->
      $(self.el).css('opacity',1)
    ,500)
  isOpen:->
    return !$('#newDreamLog-wrap').hasClass 'dreamLog_closed'
  clearActive:->
    $('.dream').removeClass 'dreamActive_editMode'



  #---------------
  # private mehtod
  #
  ballEffect:=>
    $('#submit-effect').removeClass 'bounceOut'
    $('#submit-effect').addClass 'ball'

  bounceEffect:=>
    $('#submit-effect').addClass 'bounceOut'
    $('#submit-effect').removeClass 'ball'

  addNewLog:=>
    self=@
    data={
      title:$('#title').val()
      body:$('#body').val()
    }
    newLog=new Log()
    newLog.create data
    @.listenTo newLog, 'newLogCreated', ->
      setTimeout( ->
        self.bounceEffect()
        self.close()
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
    user_icon=usersCollection.get(@model.get('user_id')).get 'thumb_url'
    @setupCalendar()
    @model.set {
      user_icon:user_icon
    }
    @render()

  render:->
    $(@el).attr 'user_id',@model.get('user_id')
    $(@el).attr 'title', @model.get('title').toLowerCase().replace(/\s+/g, '')
    $(@el).html(@template(@model.toJSON()))
    $('#dreamList').prepend @el
    
  dreamHandler:->

    # edit mode
    if editMode
      dreamLog.close()
      newDreamLog.clearActive()
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
    dreamLog.clearActive()
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
    alert 'TO-DO list'
    #@model.delete()
      
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
      self.render()

  render:->
    dreams.each (data)->
      new LogView({model:data})


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
    new HomePage()
    init()
     
  

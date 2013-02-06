class User extends Backbone.Model
  url:()->
    return "users/"+@id
  initialize:(option)->
    @id=option['id']

class Users extends Backbone.Collection
  model:User
  url:'users'

class Log extends Backbone.Model
  initialize:(option)->
  create:(data)->
    self=@
    $.post 'log/create', data, (r)->
      self.set r
      #create a new Logview
      new LogView({model:self})
      self.trigger 'newLogCreated'
       
      




class Logs extends Backbone.Collection
  model:Log
  url:'logs'

class Comment extends Backbone.Model
  initialize:(option)->


class Reply extends Backbone.Model
  initialize:(option)->
class Replies extends Backbone.Collection
  url:'replies'
  model:Reply


# views -------------------------------


dreamLog=popup=filter=leftbar=newDreamLog=logList=''
usersCollection= new Users()
dreams= new Logs()
usersCollection.fetch()

class HomePage extends Backbone.View
  el:$('body')
  events:
    'click .add_icon':'showNewDream'

  initialize:->
    @initPage()
  #----------------
  # private methods
  #----------------
  # initialize page objects
  initPage: =>
    dreamLog=new DreamLog()
    filter=new Filter()
    leftBar=new LeftBar()
    newDreamLog=new NewDreamLog()
    logList=new LogListView()
    
  showNewDream:=>
    newDreamLog.open()
      
class LeftBar extends Backbone.View
  el:$('body')
  events:
    'click #l_icon':'toggleSidebar'

  initialize:->

  toggleSidebar:=>
     if $('.left').hasClass 'left_close'
       $('.left').removeClass 'left_close'
       $('.right').removeClass 'right_expand'
       $('.add_icon').addClass 'add_icon_show'
     else
       $('.left').addClass 'left_close'
       $('.right').addClass 'right_expand'
       $('.add_icon').removeClass 'add_icon_show'

class Filter extends Backbone.View
  el:$('body')
  events:
    'click #filter':'togglePopup'
    'click .popup-option':'close'
  initialize:->
    self=@
    $(window).click (e)->
      if e.target.id isnt "filter"
         self.close()
  open:->
    $('.popup').addClass 'popup_open'
  close:->
    $('.popup').removeClass 'popup_open'
  passiveClose:(e)=>

  togglePopup:->
    if $('.popup').hasClass 'popup_open'
       @close()
    else 
       @open()
        
class DreamLog extends Backbone.View
  template:$('#dreamLog-template').generateTemplate()
  el:$('#dreamLog')
  events:
    'click .dreamLog_closeButton':'closeDL'
    'click #read':'showRead'
    'click #comments':'showComments'
  initialize:->
    self=@
  
  # ---------------
  # private methods
  # ---------------
  closeDL:=>
    @close()
  showRead:=>
    $('.comment-wrap').removeClass 'showComments'
    $('.dream_content').addClass 'showRead'
  showComments:=>
    $('.comment-wrap').addClass 'showComments'
    $('.dream_content').removeClass 'showRead'

  # ---------------
  # public methods
  # ---------------
  load:(log)->
    #load reading content
    $(@el).html(@template(log.toJSON()))
    #load comments and replies
  open:->
    if @isOpen()
      @flash()
    else
      $(@el).removeClass 'dreamLog_closed'

  close:->
    $(@el).addClass 'dreamLog_closed'

  flash:->
     self=@
     $(@el).css('opacity',0)
     setTimeout( ->
       $(self.el).css('opacity',1)
     ,500)
  isOpen:->
    if $(@el).hasClass 'dreamLog_closed'
      return false
    else
      return true

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
      

  
class LogView extends Backbone.View
  template:$('#dream-template').generateTemplate()
  tagName:'li'
  className:'dream'

  events:
    'click ':'showDream'

  initialize:->
    user_icon=usersCollection.get(@model.get('user_id')).get 'thumb_url'
    @model.set {user_icon:user_icon}
    @render()

  render:->
    $(@el).html(@template(@model.toJSON()))
    $('#dreamList').append @el
  showDream:->
    dreamLog.load @model
    if dreamLog.isOpen()
      dreamLog.flash()
    else
      dreamLog.open()


class LogListView extends Backbone.View
  el:$('#dreamList')

  initialize:->
    self=@
    dreams.on 'reset', ->
      self.render()
  render:->
    dreams.each (data)->
      new LogView({model:data})

class CommentView extends Backbone.View
  template:$('#comment-template').generateTemplate()
  tagName:'li'
  className:'comment'

  events:
    'click .allCommentLink':'showReplies'
  initialize:->

  render:->
    data=@model.toJSON()
    user= usersCollection.get 1
    data.user_name=user.get 'name'
    data.user_icon=user.get 'thumb_url'
    $(@el).html(@template(data))
    $('#comments-list').prepend @el

  # private method 
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


#----testing -----

usersCollection.on 'reset', ->
  new HomePage()
  dreams.fetch()
  #init()
  n=new Comment({
    id:1,
    body:"bill is awesome",
    user_id:1,
    flag:false,
    log_id:1
  })
  comment=new CommentView({model:n})
  comment.render()
  comment1=new CommentView({model:n})
  comment1.render()


   
  


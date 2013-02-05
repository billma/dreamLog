
class comment extends Backbone.Model
  defaults:
    user_icon:""
    user_name:""
    body:""
class dreamLog extends Backbone.Model


class HomePage
  constructor: ->
    @initPage()

  #----------------
  # private methods
  #----------------
  initPage: => 
    self=@
    @dreamLog=new DreamLog()
    @filter=new Filter()
    @leftBar=new LeftBar()
    $('.dream').click ->
      if self.dreamLog.isOpen()
        self.dreamLog.flash()
      else
        self.dreamLog.open()


class LeftBar
  constructor:->
    @setupEvents()
  setupEvents:=>
    self=@
    $('#l_icon').click ->
      self.toggleSidebar()

  toggleSidebar:=>
     if $('.left').hasClass 'left_close'
       $('.left').removeClass 'left_close'
       $('.right').removeClass 'right_expand'
       $('.add_icon').addClass 'add_icon_show'
     else
       $('.left').addClass 'left_close'
       $('.right').addClass 'right_expand'
       $('.add_icon').removeClass 'add_icon_show'

class Filter
  constructor:->
    @setupEvents()
  setupEvents:=>
    self=@
    $('#filter').click ->
      self.togglePopup()
    $('.popup-option').click ->
      self.close()
    $(window).click (e)->
       if e.target.id isnt "filter"
         self.close()

  open:->
    $('.popup').addClass 'popup_open'
  close:->
    $('.popup').removeClass 'popup_open'

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
    $(@el).html(@template())
    #testing
    comment=new Comment()
    comment.render()
    comment1=new Comment()
    comment1.render()

    @dreamLog=$('#dreamLog')
    #  @setupEvents()
    return @
  

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
  open:->
    if @isOpen()
      @flash()
    else
      @dreamLog.removeClass 'dreamLog_closed'

  close:->
    @dreamLog.addClass 'dreamLog_closed'

  flash:->
     self=@
     @dreamLog.css('opacity',0)
     setTimeout( ->
       self.dreamLog.css('opacity',1)
     ,500)

  isOpen:->
    if @dreamLog.hasClass 'dreamLog_closed'
      return false
    else
      return true



class Comment extends Backbone.View
  template:$('#comment-template').generateTemplate()
  tagName:'li'
  className:'comment'

  events:
    'click .allCommentLink':'showReplies'
  initialize:->

  render:->
    $(@el).html(@template)
    $('#comments-list').append @el

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
    
new HomePage()
#init()
    

    


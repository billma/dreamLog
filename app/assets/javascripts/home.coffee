

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
        
class DreamLog
  constructor:->
    self=@
    @dreamLog=$('#dreamLog')
    @setupEvents()
    return @
  

  # ---------------
  # private methods
  # ---------------
  setupEvents:=>
    self=@
    $('.dreamLog_closeButton').click ->
      console.log 'closing'
      self.close()
    $('#read').click ->
      $('.comment-wrap').removeClass 'showComments'
      $('.dream_content').addClass 'showRead'
    $('#comments').click -> 
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

new HomePage()
init()
    

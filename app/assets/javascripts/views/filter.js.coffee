# ---------------------------------    
#
#            Filter 
#
# =================================   
class App.Filter extends Backbone.View
  el:'body'
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

  togglePopup:->
    if $('.popup').hasClass 'popup_open' then @close() else @open()

  noFilter:->
    @mode="noFilter"
    $('.dream').show()
  userFilter:->
    @mode="userFilter"
    $('.dream').show()
    $('.dream[user_id!="'+App.currentUser.get('id')+'"]').hide()

  # ====================
  #  Private Methods
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



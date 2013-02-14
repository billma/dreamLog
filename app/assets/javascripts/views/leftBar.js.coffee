# ---------------------------------    
#
#            LeftBar 
#
# =================================       
class App.LeftBar extends Backbone.View
  el:'body'
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



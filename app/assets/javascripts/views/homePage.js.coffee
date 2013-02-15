# ---------------------------------  
#
#           HomePage
#
# =================================
class App.HomePage extends Backbone.View
  el:'body'
  events:
    'click .add_icon':'openForm'
    'click .edit_icon':'activateEditMode'
    'click .exit_edit':'exitEditMode'

  initialize:->
    self=@
    #init()
    App.currentUser = new App.CurrentUser()
    App.usersCollection= new App.Users()
    App.dreams= new App.Logs()
    App.comments=new App.Comments()
    App.replies=new App.Replies()
    App.votes=new App.Votes()
    App.usersCollection.fetch()
    App.usersCollection.on 'reset', ->
      App.currentUser.fetch success:->
        App.dreams.fetch()
        App.comments.fetch()
        App.replies.fetch()
        App.votes.fetch()
        self.setupPage()
        setTimeout ->
          $('body').addClass 'b-img'
          App.leftBar.toggleSidebar()
        ,1500
    

  #----------------
  # private methods

  # initialize page objects
  setupPage: =>
    # create dreamlog when replies are loaded
    App.replies.on 'reset', ->
      App.dreamLog=new App.DreamLog()
      
    #create leftBar
    App.leftBar=new App.LeftBar()
    #create log list
    App.logList=new App.LogListView()
    #create filter object
    App.filter=new App.Filter()
      
    App.newDreamLog=new App.NewDreamLog()
   
  # open newDreamLog view 
  openForm:=>
    App.dreamLog.close()
    App.newDreamLog.clearForm()
    App.newDreamLog.activateAddMode()
    App.newDreamLog.open()

  
  # put page into editting mode
  activateEditMode:=>
    App.editMode=true
    App.dreamLog.clearActive()
    App.newDreamLog.clearForm()
    # show only user's log
    App.filter.userFilter()
    App.filter.hide()
    App.dreamLog.close()
    $('.exit_edit, .edit_icon, .add_icon').toggle()
    $('.profileImg, .delete_icon').toggle()
    $('.dream').addClass 'dream_editMode'
    $('.profileImg-wrap').addClass 'showProfileImg'
    $('.dreamDate').addClass 'dreamDateFades'

  # exit page out of editing mode
  exitEditMode:=>
    App.editMode=false
    App.newDreamLog.close()
    App.newDreamLog.clearActive()
    App.newDreamLog.clearForm()
    # clear filter
    App.filter.noFilter()
    App.filter.show()
    $('.profileImg, .delete_icon').toggle()
    $('.exit_edit, .edit_icon, .add_icon').toggle()
    $('.dream').removeClass 'dream_editMode'
    $('.profileImg-wrap').removeClass 'showProfileImg'
    $('.dreamDate').removeClass 'dreamDateFades'





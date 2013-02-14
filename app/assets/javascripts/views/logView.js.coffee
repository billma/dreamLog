# --------------------------------        
#
#          LogListView: 
#
# ================================
# list all the view the left bar 

class App.LogListView extends Backbone.View

  el:$('#dreamList')

  initialize:->
    self=@
    # render after all dreams are loaded
    App.dreams.on 'reset', ->
       App.votes.on 'reset', ->
          self.render()

  render:->
    App.dreams.each (data)->
      lv=new App.LogView({model:data})
      $('#dreamList').prepend lv.render()



# ----------------------------------        
#
#             LogView: 
#
# ==================================
# list view for the left bar post list
class App.LogView extends Backbone.View
  tagName:'li'

  className:'dream'

  events:
    'click .dreamInfo':'showHandler'
    'click .delete_icon':'deleteLog'

  initialize:->

    @template=$('#dream-template').generateTemplate()
    # find user icon by user id
    user_icon=App.usersCollection.get(@model.get('user_id')).get 'thumb_url'

    # create calender with timestamp
    @setupCalendar()

    # set user_icon
    @model.set {
      user_icon:user_icon
      vote_counts:App.votes.getVotes(@model.id)['count']
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
    if App.editMode
      console.log "editmode in log view"
      @.$('.profileImg').hide()
      @.$('.delete_icon').show()
      @.$('.dream').addClass 'dream_editMode'
      @.$('.profileImg-wrap').addClass 'showProfileImg'
      @.$('.dreamDate').addClass 'dreamDateFades'

    return @el
  
  # show log model in either
  # dreamLog viewer (show) or newDreamLog form (edit)
  showHandler:->
    # edit mode
    if App.editMode
      App.dreamLog.close()
      App.newDreamLog.clearActive()
      $(@el).addClass 'dreamActive_editMode'
      if App.newDreamLog.isOpen()
        App.newDreamLog.flash()
      else
        App.newDreamLog.open()
      App.newDreamLog.load(@model)
    # show mode
    else
      App.newDreamLog.close()
      @dreamActive()
      App.dreamLog.load @model
      if App.dreamLog.isOpen()
        App.dreamLog.flash()
      else
        App.dreamLog.open()

  # ==================
  #  Private methods

  dreamActive:=>
    # clear previously active dreamLog
    App.dreamLog.clearActive()

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
      

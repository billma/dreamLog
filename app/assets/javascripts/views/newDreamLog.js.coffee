
#--------------------------------------        
# 
#             NewDreamLog
# 
#=====================================
# Form for creating a new dreamlog 
class App.NewDreamLog extends Backbone.View
  tagName:'div'

  id:'newDreamLog'

  events:
    'click #submit':'submit'
    'click .newDreamLog_closeButton':'close'

  initialize:->
    @template=$('#newDream-template').generateTemplate()
    @render()

  render:->
    $(@el).html @template()
    $('#newDreamLog-wrap').html @el
  
  # create log is there isn't a log
  # update a log is log exits
  submit:->
    @ballEffect()
    if @model then @updateLog() else @addNewLog()
  
  #open form
  open:->
    $('#newDreamLog-wrap').removeClass 'dreamLog_closed'
  
  # load Log model before edit
  load:(log)->
    @model=log
    @activateEditMode()
    $('#title').val log.get('title')
    $('#body').val log.get('body')

  # close form 
  close:->
    @bounceEffect()
    @clearActive()
    $('#newDreamLog-wrap').addClass 'dreamLog_closed'
    @clearForm()
  # flash form transition
  flash:->
    self=@
    $(@el).flashDiv()
    @clearForm()

  isOpen:->
    return !$('#newDreamLog-wrap').hasClass 'dreamLog_closed'
  # change form color to red
  activateEditMode:->
    @bounceEffect()
    $('#title, #body').css 'background', 'rgba(232, 44, 12, 0.1)'
    $('#submit').css 'background', 'rgba(255,72,13,0.1)'
  # change form color to blue
  activateAddMode:->
    @bounceEffect()
    $('#title, #body').css 'background', 'rgba(57, 120, 172, 0.3)'
    $('#submit').css 'background', 'rgba(57, 120, 172, 0.3)'
  
  # clear active dreams in the list
  clearActive:->
    $('.dream').removeClass 'dreamActive_editMode'
  
  # clear form inputs
  clearForm:->
    @model=null
    $('#title').val ''
    $('#body').val ''

  #---------------
  # private mehtod
  #

  # hover over effect on submit button
  ballEffect:=>
    @clearEffect()
    if @model
      $('#submit-effect').addClass 'ball_editMode'
    else
      $('#submit-effect').addClass 'ball'
  
  # loading effect on submit button
  bounceEffect:=>
    @clearEffect()
    if @model
      $('#submit-effect').addClass 'bounceOut_editMode'
    else
      $('#submit-effect').addClass 'bounceOut'
  # clear all effects
  clearEffect:=>
    $('#submit-effect').removeClass 'bounceOut_editMode'
    $('#submit-effect').removeClass 'bounceOut'
    $('#submit-effect').removeClass 'ball'
    $('#submit-effect').removeClass 'ball_editMode'

  # update a log
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

  # create a new log
  addNewLog:=>
    self=@
    data={
      title:$('#title').val()
      body:$('#body').val()
    }
    App.dreams.create data, success:(newLog)->
      setTimeout( ->
        self.bounceEffect()
        self.close()
        lv= new App.LogView {model:newLog}
        $('#dreamList').prepend lv.render()
        App.dreamLog.load(newLog)
        App.dreamLog.open()
      ,1000)


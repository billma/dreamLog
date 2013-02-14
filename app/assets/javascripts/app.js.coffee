#= require_self
#= require underscore
#= require backbone
#= require handlebar
#= require timeago
#= require_tree ./models
#= require_tree ./views

$.fn.generateTemplate=->
  source= @.html()
  return Handlebars.compile(source)

$.fn.flashDiv=->
  a=this
  this.css('opacity',0)
  setTimeout( ->
      a.css('opacity',1)
  ,500)

window.App={
  dreamLog:null
  popup:null
  filter:null
  leftBar:null
  newDreamLog:null
  logList:null
  editMode:false
  currentUser:null
  usersCollection:null
  dreams:null
  comments:null
  replies:null
  votes:null
}

$.fn.generateTemplate=function(){
  var source= this.html();
  return Handlebars.compile(source);
}
$.fn.flashDiv=function(){
  var a=this
  this.css('opacity',0)
  setTimeout(function(){
      a.css('opacity',1)
  } ,500)
}

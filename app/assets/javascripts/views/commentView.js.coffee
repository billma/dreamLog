# -------------------------------        
#
#         CommentView: 
#
# ===============================
# display each interpretation 

class App.CommentView extends Backbone.View
  tagName:'li'

  className:'comment'

  events:
    'click .allCommentLink':'showReplies'
    'keyup .addReply':'addReply'
    
  initialize:->

    @template=$('#comment-template').generateTemplate()
    @render()

  render:->
    user_id= @model.get 'user_id'
    @model.set {
      user_icon:App.usersCollection.getThumb user_id
      user_name:App.usersCollection.getName user_id
      cuser_icon:App.currentUser.get 'thumb_url'
    }
    $(@el).html(@template(@model.toJSON()))
    @loadReplies()
    $('#comments-list').prepend @el
    @.$('.timeago').timeago()

  # ================
  # private method 
  
  loadReplies:=>

    self=@
    replylist=App.replies.getCommentReplies @model.get 'id'
    if replylist.length>0
      @.$('.allCommentLink').hide()
      _.each replylist, (reply)->
        rv=new App.ReplyView {model:reply}
        self.$('.reply-list ul').append rv.render()
    else
      @.$('.reply-list').addClass 'reply-list-closed'

  # show replies that belongs to a comment
  showReplies:=>
    @toggleReplyList()
    @toggleCommentArrow()
  
  # toggle reply list
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

  addReply:(e)=>
    self=@
    if e.keyCode is 13
      @.$('.allCommentLink').hide()
      body=@.$('.addReply').val().replace(/(\r\n|\n|\r)/gm,"")
      data={
        body:body
        comment_id:@model.get 'id'
      }
      App.replies.create data, {
        success:(r)->
          rv=new App.ReplyView {model:r}
          self.$('.reply-list ul').append rv.render()
          $('.timeago').timeago()
      }
      @.$('.addReply').val('')



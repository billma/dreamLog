
class App.ReplyView extends Backbone.View
  tagName:'li'

  className:'reply'

  initialize:->
    @template=$('#reply-template').generateTemplate()

  render:->
    @model.set {
      user_name:App.usersCollection.getName @model.get('user_id')
      user_icon:App.usersCollection.getThumb @model.get('user_id')
    }
    $(@el).html @template(@model.toJSON())
    return @el



(function(){var e=function(e,t){return function(){return e.apply(t,arguments)}},t={}.hasOwnProperty,n=function(e,n){function i(){this.constructor=e}for(var r in n)t.call(n,r)&&(e[r]=n[r]);return i.prototype=n.prototype,e.prototype=new i,e.__super__=n.prototype,e};App.HomePage=function(t){function r(){return this.exitEditMode=e(this.exitEditMode,this),this.activateEditMode=e(this.activateEditMode,this),this.openForm=e(this.openForm,this),this.setupPage=e(this.setupPage,this),r.__super__.constructor.apply(this,arguments)}return n(r,t),r.prototype.el="body",r.prototype.events={"click .add_icon":"openForm","click .edit_icon":"activateEditMode","click .exit_edit":"exitEditMode"},r.prototype.initialize=function(){var e;return e=this,App.currentUser=new App.CurrentUser,App.usersCollection=new App.Users,App.dreams=new App.Logs,App.comments=new App.Comments,App.replies=new App.Replies,App.votes=new App.Votes,App.usersCollection.fetch(),App.usersCollection.on("reset",function(){return App.currentUser.fetch({success:function(){return App.dreams.fetch(),App.comments.fetch(),App.replies.fetch(),App.votes.fetch(),e.setupPage(),setTimeout(function(){return $("body").addClass("b-img"),App.leftBar.toggleSidebar()},1500)}})})},r.prototype.setupPage=function(){return App.replies.on("reset",function(){return App.dreamLog=new App.DreamLog}),App.leftBar=new App.LeftBar,App.logList=new App.LogListView,App.filter=new App.Filter,App.newDreamLog=new App.NewDreamLog},r.prototype.openForm=function(){return App.dreamLog.close(),App.newDreamLog.clearForm(),App.newDreamLog.activateAddMode(),App.newDreamLog.open()},r.prototype.activateEditMode=function(){return App.editMode=!0,App.dreamLog.clearActive(),App.newDreamLog.clearForm(),App.filter.userFilter(),App.filter.hide(),App.dreamLog.close(),$(".exit_edit, .edit_icon, .add_icon").toggle(),$(".profileImg, .delete_icon").toggle(),$(".dream").addClass("dream_editMode"),$(".profileImg-wrap").addClass("showProfileImg"),$(".dreamDate").addClass("dreamDateFades")},r.prototype.exitEditMode=function(){return App.editMode=!1,App.newDreamLog.close(),App.newDreamLog.clearActive(),App.newDreamLog.clearForm(),App.filter.noFilter(),App.filter.show(),$(".profileImg, .delete_icon").toggle(),$(".exit_edit, .edit_icon, .add_icon").toggle(),$(".dream").removeClass("dream_editMode"),$(".profileImg-wrap").removeClass("showProfileImg"),$(".dreamDate").removeClass("dreamDateFades")},r}(Backbone.View)}).call(this);
Template.app_layout.onCreated ->
  Session.set "ruleMaker.ruleID", null
  document.title = "Rule Maker"
  @autorun =>
    currentUser = Meteor.userId()
    if currentUser?
      @subscribe "myRules", {}
      @subscribe "myQueue"
      # @subscribe "hasResult", Session.get("ruleMaker.ruleID")


Template.app_layout.helpers
  readyToRoll: ->
    not Meteor.loggingIn() and Template.instance().subscriptionsReady()

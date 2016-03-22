Template.app_layout.onCreated ->
  Session.set "currentRuleID", null

  ## "Static" ("Factory") subscriptions moved in to here
  @objectsFromFactory = @subscribe "objectsFromFactory"
  # @instrumentsFromFactory = @subscribe "instrumentsFromFactory"

  # document.title = "Rule Maker"
  @autorun =>
    currentUser = Meteor.userId()
    if currentUser?
      @subscribe "myRules", {}
      @subscribe "myQueue"
      # @subscribe "hasResult", Session.get("currentRuleID")


Template.app_layout.helpers
  readyToRoll: ->
    not Meteor.loggingIn() and Template.instance().subscriptionsReady()

Template.app_layout.destroyed = ->
  Session.set "currentRuleID", null

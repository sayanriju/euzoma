Template.showResults.onCreated ->
  @subsReady = new ReactiveVar()

  @autorun =>
    unless (Session.get("currentRuleID")? and Rules.findOne({_id: Session.get("currentRuleID")}).hasResult is true)
      console.log '!!!!!!!!No Results!!!!!!!!'
      FlowRouter.go '/rules'

    handle = subsManager.subscribe('singleRuleFull', Session.get("currentRuleID"));
    @subsReady.set(handle.ready());

  #   @subscribe "hasResult", Session.get("currentRuleID")

  #   if Session.get("currentRuleID")?
  #     ## Empty the local nodes and edges , etc. etc.
  #     localNodes.remove({})
  #     localEdges.remove({})
  #     localDataDesc.remove({})
  #     localPrefs.remove({})
  #     ## Now load the local stuff from loaded rule
  #     loadedRule = Rules.findOne({_id: Session.get("currentRuleID")})
  #     for item in loadedRule.localNodes
  #       localNodes.insert item
  #     for item in loadedRule.localEdges
  #       localEdges.insert item
  #     for item in loadedRule.localDataDesc
  #       localDataDesc.insert item
  #     for item in loadedRule.localPrefs
  #       localPrefs.insert item



Template.ruleMaker.onRendered ->
  # console.log $('[rel=tooltip]').size()
  # $('[rel=tooltip]:not(".disabled")').tooltip({placement: 'auto bottom'})
  $('[rel=tooltip]').tooltip({placement: 'auto bottom'})

Template.showResults.helpers
  isSubsReady: ->
    Template.instance().subsReady.get()
  ruleName: ->
    if Session.get("currentRuleID")?
      Rules.findOne({_id: Session.get("currentRuleID")})?.name
    else
      return 'New Rule'
  savedAt: ->
    if Session.get("currentRuleID")?
      sa = Rules.findOne({_id: Session.get("currentRuleID")})?.savedAt
      return "Saved At: " + moment(sa).format('MMM DD, YYYY HH:mm:ss')
    else
      return 'Not Yet Saved!'

  hasResultsToShow: ->
    Session.get("currentRuleID")? and Rules.findOne({_id: Session.get("currentRuleID")}).hasResult is true
  ########################################################################
  # isInQueue: ->
  #   Session.get("currentRuleID")? and Queue.find({ruleID: Session.get("currentRuleID")}).count()
  # isProcessing: ->
  #   # return true
  #   Session.get("currentRuleID")? and not Queue.find({ruleID: Session.get("currentRuleID")}).count() and not Rule.findOne({_id: Session.get("currentRuleID")}).hasResult
  # canViewResults: ->
  #   Session.get("currentRuleID")? and Rule.findOne({_id: Session.get("currentRuleID")}).hasResult and not Queue.find({ruleID: Session.get("currentRuleID")}).count() and not Template.instance().addingToQueue.get()


Template.showResults.events
  "click #viewRule": (e, t) ->
    unless $(e.target).hasClass("disabled")
      FlowRouter.go '/rules'

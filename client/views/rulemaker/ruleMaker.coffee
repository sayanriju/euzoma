Template.ruleMaker.onCreated ->
  @savingRule = new ReactiveVar false
  @addingToQueue = new ReactiveVar false
  # @autorun =>
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

Template.ruleMaker.helpers
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

  isSavingRule: ->
    Template.instance().savingRule.get()
  isRuleSaved: ->
    !! Session.get("currentRuleID")?
  isInQueue: ->
    Session.get("currentRuleID")? and Queue.find({ruleID: Session.get("currentRuleID")}).count()
  isProcessing: ->
    # return true
    Session.get("currentRuleID")? and not Queue.find({ruleID: Session.get("currentRuleID")}).count() and not Rule.findOne({_id: Session.get("currentRuleID")}).hasResult
  canViewResults: ->
    Session.get("currentRuleID")? and Rule.findOne({_id: Session.get("currentRuleID")}).hasResult and not Queue.find({ruleID: Session.get("currentRuleID")}).count() and not Template.instance().addingToQueue.get()


Template.ruleMaker.events
  "click #refreshForNew": (e, t) ->
    if localNodes.find().count() or localDataDesc.find().count()
      return false unless confirm "You will loose all Unsaved information! Continue?"
    # Session.set "currentRuleID", null
    location.reload()
    # console.log 'reloaded'

  "click #addDataDesc, click #addPrefs": (e, t) ->
    alert "Format not yet provided!!!"

  "click #editRuleName": (e, t) ->
    unless $(e.target).hasClass("disabled")
      oldName = Rules.findOne({_id: Session.get("currentRuleID")})?.name
      newName = prompt "Enter New Name: ", oldName
      if newName? and newName isnt oldName
        Rules.update  {_id: Session.get("currentRuleID")},{$set:{name: newName}}

  "click #addNode": (e, t) ->
    Modal.show('addNodeModal')

  "click #addData": (e, t) ->
    Modal.show('addDataModal')

  "click #viewResults": (e, t) ->
    unless $(e.target).hasClass("disabled")
      unless Rule.findOne({_id: Session.get("currentRuleID")}).hasResult
        alert "Results not yet ready!"
      window.open("google.com")

  "click #loadRule": (e, t) ->
    Modal.show('loadRuleModal')

  "click #saveRule": (e, t) ->
    unless $(e.target).hasClass("disabled")
      if Session.get("currentRuleID")?
        return unless confirm "Your Rule shall be Overwritten with the changes (if any) and re-added to Job Queue.\nPress Cancel if this is not what you want."

      if localNodes.find().count() is 0
        return unless confirm "You haven't added any Nodes to your rule!
        You sure you want to Save this?"
      else if localDataDesc.find().count() is 0
        return unless confirm "You haven't added any Data to your rule!
        You sure you want to Save this?"

      t.savingRule.set(true)
      ruleSaveObj =
        # ruleID : Session.get("currentRuleID") if Session.get("currentRuleID")?
        # name = Rules.findOne({_id: Session.get("currentRuleID")})?.name if Session.get("currentRuleID")?
        localNodes: localNodes.find({}).fetch()
        localEdges: localEdges.find({}).fetch()
        localDataDesc: localDataDesc.find({}).fetch()
        localPrefs: localPrefs.find({}).fetch()
      ruleSaveObj.ruleID = Session.get("currentRuleID") if Session.get("currentRuleID")?

      Meteor.call "upsertRule", ruleSaveObj, (error, ruleID) ->
        if error
          console.log "error", error
          t.savingRule.set(false)
        if ruleID
          Session.set "currentRuleID", ruleID
          t.savingRule.set(false)
          ## Add to queue
          t.addingToQueue.set(true)
          Meteor.call "addToQueue", ruleSaveObj, ruleID, (error, result) ->
            if error
              console.log "error", error
            # if result
            t.addingToQueue.set(false)

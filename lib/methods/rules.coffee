Meteor.methods
  "saveRule": (obj) ->
    unless Meteor.userId()
      throw new Meteor.Error("not-logged-in", "You need to be logged in to do this")

    obj.name = "Rule#"+Random.hexString(6)
    obj.savedAt = new Date()
    obj.userId = Meteor.userId()
    obj.hasResult =  false
    # console.log obj
    ruleID = Rules.insert obj
    return ruleID

  "upsertRule": (obj) ->
    unless Meteor.userId()
      throw new Meteor.Error("not-logged-in", "You need to be logged in to do this")

    unless obj.ruleID?  ## INSERT mode
      console.log 'insert mode'
      obj.name = "Rule#"+Random.hexString(6)
      obj.savedAt = new Date()
      obj.userId = Meteor.userId()
      obj.hasResult =  false
      obj.results = null
      # console.log obj
      ruleID = Rules.insert obj
      return ruleID

    else          ## UPDATE Mode
      ## Check if same user's rule
      console.log 'update mode'
      if Rules.findOne({_id: obj.ruleID})?.userId is Meteor.userId()
        obj.savedAt = new Date()
        obj.hasResult = false
        obj.results = null
        Rules.update({_id: obj.ruleID}, {$set: obj})
        return obj.ruleID
      else
        throw new Meteor.Error("wrong-user", "This is not your Rule to save")

  "processRule": (ruleID) ->
    # console.log 'started method processRule......'
    unless Meteor.userId()
      throw new Meteor.Error("not-logged-in", "You need to be logged in to do this")

    # rule = Rules.findOne({_id: obj.ruleID})
    unless Rules.findOne({_id: ruleID})?.userId is Meteor.userId()
      throw new Meteor.Error("wrong-user", "This is not your Rule to save")

    ## (1) Do the needful if required to remould data from the rule to
    ## (2) call server method `runR` with it, and finally
    ## (3) remould (if req) & write the result the method returns

    ruleData = {}  # for now!
    Meteor.call "server.runR", ruleData, (error, response) ->
      # console.log "got result from runR %o", response

      results = response ## for now!
      Rules.update {_id: ruleID}, {
        $set:
          hasResult: results?
          results: results
      }

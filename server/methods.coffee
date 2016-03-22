Meteor.methods
  "server.runR": (ruleData) ->
    console.log 'started method runR........'
    this.unblock()
    #
    # ## For now, just wait for a couple of mins and return dummy data
    Meteor._sleepForMs 5000 #120000

    ret = {
      account_evolution_table: JSON.parse(Assets.getText('dummy/account_evolution_table.json'))
      per_trade_statistics: JSON.parse(Assets.getText('dummy/per_trade_statistics.json'))
      position_data: JSON.parse(Assets.getText('dummy/position_data.json'))
      trade_statistics: JSON.parse(Assets.getText('dummy/trade_statistics.json'))
      transaction_table: JSON.parse(Assets.getText('dummy/transaction_table.json'))
      underlying_data: JSON.parse(Assets.getText('dummy/underlying_data.json'))
    }
    # console.log "results: %o", ret
    console.log 'finished method runR.......'
    return ret

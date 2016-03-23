Template.results_tables.helpers
  availableTables: ->
    [
      "account_evolution_table"
      "per_trade_statistics"
      "position_data"
      "trade_statistics"
      "transaction_table"
      "underlying_data"
    ]
  formatTableName: (name)->
    name.replace(/_/g,' ').toUpperCase()
  getTableData: ()->
    # console.log this
    # console.log Rules.findOne({_id: Session.get("currentRuleID")})?.results[this]
    return Rules.findOne({_id: Session.get("currentRuleID")})?.results[this]

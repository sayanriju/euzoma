Template.addDataModal.onCreated ->
  # @instrumentsFromFactory = @subscribe "instrumentsFromFactory"
  @selectedData = null

Template.addDataModal.helpers
  hasDataDesc: ->
    !! localDataDesc.find().count()
  currentDataDesc: ->
    localDataDesc.find({})

  settings: ->
    return {
      limit: 25
      rules: [
        {
          collection: 'instrumentFactory' ## String means server side collection
          field: 'desc'
          template: Template.autocompleteInstrument
        },
        # {
        #   collection: instrumentFactory
        #   field: 'tcr'
        # }
      ]
    }

Template.addDataModal.events
  "autocompleteselect input": (e, t, doc)->
    # console.log 'selected ', doc
    t.selectedData = doc

  "click #saveDataDesc": (e, t) ->
    if t.selectedData?
      # console.log 'try to save..........', t.selectedData, $('.period-select').val()
      localDataDesc.insert
        instrument: t.selectedData
        periodicity: $('.period-select').val()

      Modal.hide('addDataModal')
    else
      alert "You didn't select anything!"

Template.addDataModal.onCreated ->
  @instrumentsFromFactory = @subscribe "instrumentsFromFactory"

Template.addDataModal.helpers
  settings: ->
    return {
      limit: 25
      rules: [
        {
          collection: instrumentFactory
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
  "click #saveDataDesc": (e, t) ->

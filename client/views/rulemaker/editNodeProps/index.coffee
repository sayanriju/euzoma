Template.editNodePropsModal.onRendered ->
  $('#editedJSON').focus()
  @errorMsg = new ReactiveVar ''

Template.editNodePropsModal.helpers
  propsJSON: ->
    JSON.stringify @props, undefined , 2

Template.editNodePropsModal.events
  "click #saveEditedJson": (e, t) ->
    try
      edited = JSON.parse $('#editedJSON').val()
      localNodes.update {_id: @._id}, {$set: {props: edited}}
      Modal.hide('editNodePropsModal')
    catch error
       toastr.error 'invalid json'

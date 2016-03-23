Meteor.startup ->
  BlazeLayout.setRoot('#app_layout');

  if Meteor.isClient
    @subsManager = new SubsManager(); ## used in showResults 

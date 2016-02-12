FlowRouter.route '/',
  action: (params) ->
    BlazeLayout.render("app_layout", {page: "ruleMaker"});

FlowRouter.route '/logout',
  action: (params) ->
    Meteor.logout ->
      FlowRouter.go('/')

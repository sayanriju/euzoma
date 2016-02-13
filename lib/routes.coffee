FlowRouter.route '/',
  action: (params) ->
    # BlazeLayout.render("app_layout", {page: "ruleMaker"});
    FlowRouter.redirect('/rules')
FlowRouter.route '/rules',
  action: (params) ->
    # console.log params.ruleId
    BlazeLayout.render("app_layout", {page: "ruleMaker"});

FlowRouter.route '/logout',
  action: (params) ->
    Meteor.logout ->
      FlowRouter.go('/')

FlowRouter.notFound =
  action: ->
    BlazeLayout.render("app_layout", {page: "four0four"});

FlowRouter.route '/',
  action: (params) ->
    BlazeLayout.render("app_layout", {page: "ruleMaker"});

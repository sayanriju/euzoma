Meteor.startup ->
	# if Meteor.isServer
	if objectFactory.find({}).count() is 0
		console.log objectFactory.find({}).count()
		for nodeObj in JSON.parse(Assets.getText("nodeTypes.json"))
			objectFactory.insert nodeObj
		console.log "added prototype objects...."
	else
		console.log "No node object added"

	if instrumentFactory.find({}).count() is 0
		console.log instrumentFactory.find({}).count()
		for instrument in JSON.parse(Assets.getText("instruments.json"))
			delete instrument._id
			instrumentFactory.insert instrument
		console.log "added prototype instruments...."
	else
		console.log "No instrument added"


  ## add a demo user
  unless Meteor.users.find().count()
    Accounts.createUser
      username: "demo"
      password: "demo"
    console.log "added a demo user"
  else
    console.log "no new user added"

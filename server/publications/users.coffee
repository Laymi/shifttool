# We publish the Meteor.users to everyone who is logged in
Meteor.publish null, ->
  if this.userId
    allUsers = Meteor.users.find().fetch()
    self = this
    # We loop through every single user to
    _.each allUsers, (user) ->
      # Remove the bcrypted password and login hashes from the publication
      delete user.services
      self.added('users', user._id, user)
  @ready()

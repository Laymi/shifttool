###if Meteor.isServer
  Accounts.onCreateUser (options, user) ->
    user.profile = options.profile
    return user
###

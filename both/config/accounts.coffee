if Meteor.isServer
  Accounts.onCreateUser (options, user) ->
    user.profile = options.profile
    user.profile.birthday = new Date user.profile.birthday
    return user

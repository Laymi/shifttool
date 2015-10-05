Meteor.methods
  saveUser: (user) ->
    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      check user, Object
      Meteor.users.update { _id: user._id }, $set: 'profile.role': user.role

Meteor.methods
  deleteShiftById: (_id) ->
    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      check _id, String
      Shifts.remove _id

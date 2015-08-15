Meteor.methods
  deleteShiftById: (_id) ->
    check _id, String
    Shifts.remove _id

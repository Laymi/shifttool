Meteor.methods
  addNewShift: (newShift) ->
    check newShift, Object
    Shifts.insert newShift

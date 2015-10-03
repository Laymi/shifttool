Meteor.methods
  listShiftForExchange: (shift, userId) ->
    check shift, String
    check userId, String
    # Shifts.update shift, $set: exchangable:true
    Shifts.update shift, $addToSet: listedAsExchangableBy: userId

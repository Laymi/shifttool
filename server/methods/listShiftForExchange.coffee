Meteor.methods
  listShiftForExchange: (shift, userId) ->
    check shift, String
    check userId, String
    # Shifts.update shift, $set: exchangeable:true
    Shifts.update shift, $addToSet: listedAsExchangeableBy: userId

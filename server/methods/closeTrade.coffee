Meteor.methods
  'closeTrade': (_id) ->
    check _id, String

    trade = Trades.findOne(_id)
    accepterId = Meteor.userId()


    # Step 1: Validate that the user who wants to close the trade is allowed to
    emailOfMeteorUser = Meteor.users.findOne(accepterId)?.emails?[0]?.address
    studentIdOfTheAcceptingUser = Students.findOne('email':{$regex: new RegExp(emailOfMeteorUser, "i")})?._id
    allShiftsOfTheAcceptingUser = Shifts.find('assignedStudents': $in: [ studentIdOfTheAcceptingUser ]).fetch()

    # console.log 'emailOfMeteorUser', emailOfMeteorUser
    # console.log 'studentIdOfTheAcceptingUser', studentIdOfTheAcceptingUser
    # console.log 'allShiftsOfTheAcceptingUser', allShiftsOfTheAcceptingUser
    validated = false

    for shift in allShiftsOfTheAcceptingUser
      if shift._id == trade.shiftOfferedFor
        console.log 'shift._id',shift._id,'== trade.shiftOfferedFor', trade.shiftOfferedFor
        validated = true

    if validated
      # console.log 'Validation successful'

      # Step 2: Remove both users from their shifts
      # Firstly the requester
      # console.log 'Attempt to remove',trade.requester, 'from', trade.shiftOfferedInExchange
      Shifts.update({_id:trade.shiftOfferedInExchange},{$pull: {assignedStudents:trade.requester}})
      # Then the accepter
      # console.log 'Attempt to remove',studentIdOfTheAcceptingUser, 'from', trade.shiftOfferedFor
      Shifts.update({_id:trade.shiftOfferedFor},{$pull: {assignedStudents:studentIdOfTheAcceptingUser}})

      # Step 3: Add both users to the other's shift
      # Firstly the requester
      # console.log 'Attempt to add',trade.requester, 'to', trade.shiftOfferedFor
      Shifts.update({_id:trade.shiftOfferedFor},{$addToSet: {assignedStudents:trade.requester}})
      # Then the accepter
      # console.log 'Attempt to add',studentIdOfTheAcceptingUser, 'to', trade.shiftOfferedInExchange
      Shifts.update({_id:trade.shiftOfferedInExchange},{$addToSet: {assignedStudents:studentIdOfTheAcceptingUser}})

      # Step 4: Remove the exchange flags for the requester and delete the trade
      Shifts.update({_id:trade.shiftOfferedInExchange},{$pull: {listedAsExchangeableBy:trade.requester}})
      Shifts.update({_id:trade.shiftOfferedFor},{$pull: {listedAsExchangeableBy:studentIdOfTheAcceptingUser}})

      Trades.remove(_id:_id)

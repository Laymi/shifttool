Meteor.methods
  'initializeShiftTrade': (requestingStudentId, shiftOfferedFor, shiftOfferedInExchange) ->
    check requestingStudentId, String
    check shiftOfferedFor, String
    check shiftOfferedInExchange, String

    # console.log 'requestingStudentId',requestingStudentId
    # console.log 'shiftOfferedFor',shiftOfferedFor
    # console.log 'shiftOfferedInExchange',shiftOfferedInExchange

    # Some validation
    currentUsersEmail = Meteor.users.findOne(Meteor.userId())?.emails?[0]?.address
    currentStudentsId = Students.findOne(email:currentUsersEmail)?._id

    unless requestingStudentId == currentStudentsId
      throw new Meteor.Error("inconsistent data", "The requesting user is not the one who is logged in.");

    # Create Trade Document

    recipients = Shifts.findOne(shiftOfferedFor).listedAsExchangableBy

    newTrade =
      _id: Random.id() # Also the security token. Complexity of 62^17 Should be fine
      requester: requestingStudentId
      shiftOfferedFor: shiftOfferedFor
      shiftOfferedInExchange: shiftOfferedInExchange
      recipients: recipients # Theoretically redundant but makes later calls much easier

    Trades.insert newTrade

    # Notify the recipients that someone has offered on their shift

    # Meteor.call 'sendEmail', 'service@danielpesch.com', 'test@test.test', 'hi', 'Notified moi$'

    Mandrill.messages.send
      message:
        subject: 'Test Mail'
        text: "Example text content"
        from_email: 'service@danielpesch.com'
        to: [
            email: 'service@danielpesch.com'
        ]

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

    if requestingStudentId == currentStudentsId
      recipients = Shifts.findOne(shiftOfferedFor).listedAsExchangeableBy
      # Create Trade Document
      newTrade =
        _id: Random.id() # Also the security token. Complexity of 62^17 Should be fine
        requester: requestingStudentId
        shiftOfferedFor: shiftOfferedFor
        shiftOfferedInExchange: shiftOfferedInExchange
        recipients: recipients # Theoretically redundant but makes later calls much easier

      Trades.insert newTrade

      # Notify the recipients that someone has offered on their shift
      nameOfRecipient = Students.findOne(requestingStudentId).first_name

      Mandrill.messages.send
        message:
          subject: 'You have received a new shift trade offer.'
          text: "Hello "+nameOfRecipient+", \n\r
          You have received a new shift trade offer for one of you listed shifts.\n\r
          Please click on this link to answer the offer: http://shift.whu.edu/acceptTrade/"+newTrade._id+"/ \n\r\n\r
          The shifttool\n\r
          Please do not reply to this automatically generated e-mail."
          from_email: 'service@danielpesch.com'
          to: [
              email: 'service@danielpesch.com'
          ]

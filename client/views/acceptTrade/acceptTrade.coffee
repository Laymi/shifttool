Template.acceptTrade.helpers
  trade: ->
    Trades.findOne(Router?.current()?.params?._id)

  userId: ->
    console.log Trades.findOne(Router?.current()?.params?._id)
    Meteor.userId()

  formatDate: (date) ->
    moment(date).format('DD-MM-YYYY hh:mm:ss')

Template.acceptTrade.rendered = ->
  document.getElementById('searchStudent')?.value = ''
  Session.set('possibleStudents', undefined)
  console.log 'Router?.current()?.params?._id', Router?.current()?.params?._id

Template.acceptTrade.events
  "click #acceptOffer": (event) ->
    console.log 'accepted Offer'

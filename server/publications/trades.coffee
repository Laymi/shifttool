Meteor.publish 'specificTrade', (_id) ->
  check _id, String
  if this.userId
    Trades.find(_id)
  else
    @ready()

Meteor.publish 'specificTrade', (_id) ->
  check _id, String
  Trades.find(_id)

Schemas.UserProfile = new SimpleSchema
  firstName:
    type: String
    regEx: /^[a-zA-Z-]{2,25}$/
  lastName:
    type: String
    regEx: /^[a-zA-Z]{2,25}$/

Schemas.User = new SimpleSchema
  emails:
    type: [ Object ]
    optional: true
  'emails.$.address':
    type: String
    regEx: SimpleSchema.RegEx.Email
  'emails.$.verified':
    type: Boolean
  profile:
    type: Schemas.UserProfile
    label: ' '
    optional: true
  services:
    type: Object
    optional: true
    blackbox: true
  # Force value to be current date (on server) upon insert
  # and prevent updates thereafter.
  createdAt:
    type: Date
    autoValue: ->
      if @isInsert
        return new Date
      else if @isUpsert
        return { $setOnInsert: new Date }
      else
        @unset()
    autoform:
      omit: true

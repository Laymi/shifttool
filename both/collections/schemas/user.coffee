Schemas.UserProfile = new SimpleSchema
  firstName:
    type: String
    regEx: /^[a-zA-Z-]{2,25}$/
  lastName:
    type: String
    regEx: /^[a-zA-Z]{2,25}$/
  birthday:
    type: Date
  gender:
    type: String
    allowedValues: ['male', 'female']
    autoform: {
      options: [
        {label: "Male", value: "male"},
        {label: "Female", value: "female"}
      ]
    }
  qualification:
    type: String
    allowedValues: ['secondary_school', 'graduate', 'professional']
    autoform: {
      options: [
        {label: 'Secondary School', value: 'secondary_school'}
        {label: 'Graduate', value: 'graduate'}
        {label: 'Professional', value: 'professional'}
      ]
    }
  organization:
    type: String
    regEx: /^[a-z0-9A-z .]{3,30}$/
    optional: true
  website:
    type: String
    regEx: SimpleSchema.RegEx.Url
    optional: true
  country:
    type: String
    autoform: {
      options: [
        # Add a full list of countries later
        {label: 'America', value: 'america'}
        {label: 'Germany', value: 'germany'}
      ]
    }

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

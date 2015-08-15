###Schemas.Shifts = new SimpleSchema
  info:
    type: Object
    optional: true
    blackbox: true
  info =
    supervisor: "Daniel Pesch"
    supervisorContact: "+123456789"
    location: "Burgplatz"
    info: "normale Klamotten"
    start: new Date
    end: new Date
  assignedStudents:
    type: Array
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
###

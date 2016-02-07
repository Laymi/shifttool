Template.student_profile.helpers

  first_name: ->
    Students.findOne(Router.current().params._id).first_name

  last_name: ->
    Students.findOne(Router.current().params._id).last_name

  gender: ->
    Students.findOne(Router.current().params._id).gender

  track: ->
    Students.findOne(Router.current().params._id).track

  email: ->
    Students.findOne(Router.current().params._id).email

  mobile: ->
    Students.findOne(Router.current().params._id).mobile

  workload: ->
    Students.findOne(Router.current().params._id).workload

  exemptionStatus: ->
    Students.findOne(Router.current().params._id).exemptionStatus

#Meteor.subscribe 'allShifts'
Template.Individual.helpers
  shifts: ->
    shifts = Shifts.find().fetch()
    if shifts.length then shifts else null

  userId: ->
    Router?.current()?.params?._id

  first_name: ->
    Students.findOne(Router?.current()?.params?._id).first_name

  last_name: ->
    Students.findOne(Router?.current()?.params?._id).last_name

  formatDate: (date) ->
    moment(date).format('DD-MM-YYYY hh:mm:ss')

Template.Individual.rendered = ->
  document.getElementById('searchStudent').value = ''
  Session.set('possibleStudents', undefined)

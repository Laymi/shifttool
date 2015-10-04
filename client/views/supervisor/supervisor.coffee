Meteor.subscribe 'allShifts'
Template.Supervisor.helpers
  formatDate: (date) ->
    moment(date).subtract(2, 'hours').format('DD-MM-YY')

  formatTime: (date) ->
    moment(date).subtract(2, 'hours').format('hh:mm')

  supervisor_id: ->
    Router?.current()?.params?._id

  supervisor_name: ->
    Students.findOne(Router?.current()?.params?._id).first_name + ' ' + Students.findOne(Router?.current()?.params?._id).last_name

  shifts: ->
    shifts = Shifts.find().fetch()
    if shifts.length then shifts else null

Template.Supervisor.events
  "click .editbtn": (event) ->
    event.preventDefault()
    if confirm 'Do you really want to edit the user ' + document.getElementById(event.target.name + '-' + 'email').innerText
      alert 'We will now delete the user and prefill the user creation inputs'
      document.getElementById('email').value = document.getElementById(event.target.name + '-' + 'email').innerText
      document.getElementById('role').value = document.getElementById(event.target.name + '-' + 'role').innerText
      document.getElementById('_id').value = document.getElementById(event.target.name + '-' + '_id').innerText

  "click #checkStudent": ->
    event.preventDefault()
    user =
      "_id": document.getElementById('_id').value
      "role" : document.getElementById('role').value

    Meteor.call 'checkStudent', user
    
    toastr.success 'Saved!'
 

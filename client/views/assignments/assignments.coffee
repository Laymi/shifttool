Template.Assignments.helpers

  shifts: ->
    shifts = Shifts.find().fetch()
    if shifts.length then shifts else null

  userId: ->
    Router?.current()?.params?._id

  formatDate: (date) ->
    moment(date).format('MM-DD-YYYY hh:mm:ss')

  students: ->
    students = Students.find().fetch()
    if students.length then students else null

Template.Assignments.events
  'click #manuallyAssignStudentToShift': ->
    Meteor.call 'assignStudentToShift', document.getElementById('manualStudentSelection').value, document.getElementById('manualShiftSelection').value

  'click #automaticallyAssignStudentsToShift': ->
    shiftId = document.getElementById('automaticShiftSelection').value
    studentN = parseInt(document.getElementById('studentN').value)

    Meteor.call 'automaticallyAssignStudentsToShift', shiftId, studentN, (err, res) ->
      if err
        toastr.error err.error
      else
        toastr.success 'Ok.'

  'focus #studentN': ->
    studentN.value = Shifts.findOne(automaticShiftSelection.value)?.workload or ''

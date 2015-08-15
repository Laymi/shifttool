#Meteor.subscribe 'allShifts'
Template.Students.helpers
  students: ->
    students = Students.find().fetch()
    if students.length then students else null

Template.Students.events
  "click .deletebtn": (event) ->
    event.preventDefault()
    if confirm 'Do you really want to delete the student ' + event.target.name
      Meteor.call 'deleteStudentById', event.target.name

  "click #addNewStudent": (event) ->
    event.preventDefault()
    newStudent =
      "_id": Random.id()
      "first_name" : document.getElementById('first_name').value
      "last_name" : document.getElementById('last_name').value
      "workload" : document.getElementById('workload').value
      "exemptionStatus" : document.getElementById('exemptionStatus').value
      "createdAt": new Date

    Meteor.call 'addNewStudent', newStudent

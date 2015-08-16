#Meteor.subscribe 'allShifts'
Template.Students.helpers
  students: ->
    students = Students.find().fetch()
    if students.length then students else null

Template.Students.events
  "click .editbtn": (event) ->
    event.preventDefault()
    if confirm 'Do you really want to edit the student ' + event.target.name
      alert 'We will now delete the user and prefill the user creation inputs'
      Meteor.call 'deleteStudentById', event.target.name
      document.getElementById('first_name').value = document.getElementById(event.target.name + '-' + 'first_name').innerText
      document.getElementById('last_name').value = document.getElementById(event.target.name + '-' + 'last_name').innerText
      document.getElementById('workload').value = document.getElementById(event.target.name + '-' + 'workload').innerText
      document.getElementById('exemptionStatus').value = document.getElementById(event.target.name + '-' + 'exemptionStatus').innerText
      document.getElementById('_id').value = document.getElementById(event.target.name + '-' + '_id').innerText

  "click .deletebtn": (event) ->
    event.preventDefault()
    if confirm 'Do you really want to delete the student ' + event.target.name
      Meteor.call 'deleteStudentById', event.target.name

  "click #addNewStudent": (event) ->
    event.preventDefault()
    newStudent =
      "_id": document.getElementById('_id').value or Random.id()
      "first_name" : document.getElementById('first_name').value
      "last_name" : document.getElementById('last_name').value
      "workload" : document.getElementById('workload').value
      "exemptionStatus" : document.getElementById('exemptionStatus').value
      "createdAt": new Date

    Meteor.call 'addNewStudent', newStudent

    document.getElementById('_id').value = ''

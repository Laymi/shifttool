Template.Login.helpers
  students: ->
    students = Login.find().fetch()
    if students.length then students else null

Template.Login.events
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

  "click #loginUser": (data) ->
    data =
      email: document.getElementById('email').value.replace('@whu.edu','')
      password: document.getElementById('password').value

    ###Meteor.loginWithPassword data.email, data.password, (error) ->
      if error
        toastr.error error.reason
        console.error 'login error ', error, 'for user ', data.email
      else
        console.error 'login successful for user ', data.email###

    Meteor.call 'loginWithPAP', data.email, data.password, (err) ->
      if err
        console.log err.reason
      else
        Meteor.loginWithPassword data.email+'@whu.edu', data.password

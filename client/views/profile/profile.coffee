Template.Profile.helpers
 
  userId: ->
    Router?.current()?.params?._id

  first_name: ->
    Students.findOne(Router?.current()?.params?._id).first_name

  last_name: ->
    Students.findOne(Router?.current()?.params?._id).last_name

  gender: ->
    Students.findOne(Router?.current()?.params?._id).gender

  track: ->
    Students.findOne(Router?.current()?.params?._id).track

  email: ->
    Students.findOne(Router?.current()?.params?._id).email

  mobile: ->
    Students.findOne(Router?.current()?.params?._id).mobile

  workload: ->
    Students.findOne(Router?.current()?.params?._id).workload

  exemptionStatus: ->
    Students.findOne(Router?.current()?.params?._id).exemptionStatus


Template.profile.rendered = ->
  document.getElementById('searchStudent').value = ''
  Session.set('possibleStudents', undefined)

Template.profile.events
  "click #listShiftForExchange": (event) ->
    shiftId = event.currentTarget.name
    # console.log 'shiftId', shiftId

    #I hate this stupid package... look for a new one later or use leanModal
    MaterializeModal.confirm
      title: 'Initialize shift exchange'
      message: 'Do you want to list your shift in the shift exchange?'
      callback: (yesNo) ->
          if yesNo
              Meteor.call "listShiftForExchange", shiftId, Router?.current()?.params?._id
              Router.go('exchange');
          else
              Materialize.toast("Too bad")

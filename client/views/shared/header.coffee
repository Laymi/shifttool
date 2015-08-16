Template.Header.helpers
  isActiveRoute: (name) ->
    if name is Router.current().route.getName() then 'active' else ''

  candidate: ->
    Session.get('possibleStudents')

Template.Header.events
  'keyup input': (event, template) ->
    if event.target.value != ''
      search = new RegExp(event.target.value, 'i');
      possibleStudents = Students.find("first_name": search).fetch()
      Session.set('possibleStudents', possibleStudents)
    else
      Session.set('possibleStudents', undefined)
    #console.log 'possibleStudents', possibleStudents, event.target.value
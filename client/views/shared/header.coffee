Template.Header.helpers
  isActiveRoute: (name) ->
    if name is Router.current().route.getName() then 'active' else ''

  candidate: ->
    Session.get('possibleStudents')

  currentUserIsAdmin: ->
    return Meteor.user()?.profile?.role == 'admin'

  currentUserIsSupervisor: ->
    return Meteor.user()?.profile?.role == 'supervisor'

  isSelected: (path) ->
    if path == Router.current().originalUrl.split('/')[Router.current().originalUrl.split('/').length-1]
      "isSelected"

Template.Header.events
  'keyup input': (event, template) ->
    if event.target.value != ''
      search = new RegExp(event.target.value, 'i');
      possibleStudents = Students.find($or : [{"first_name": search},{"last_name": search}]).fetch()
      Session.set('possibleStudents', possibleStudents)
    else
      Session.set('possibleStudents', undefined)

  'click #logout': ->
    Meteor.logout()

  'click #login': ->
    provider = 'shibboleth-idp'
    Meteor.loginWithSaml { provider: provider }, (err, result) ->
      if err
        console.log err
      else
        location = '/'
      return
    #OR: Legacy/Development accounts via static route:
    #location = "/login"

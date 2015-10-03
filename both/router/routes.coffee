Router.configure
  notFoundTemplate: 'NotFound'
  loadingTemplate: 'Loading'
  templateNameConverter: 'upperCamelCase'
  routeControllerNameConverter: 'upperCamelCase'
  layoutTemplate: 'MasterLayout'

# For individual route configuration, see /client/controllers
Router.map ->
# All routes for the normal users
  @route 'home',
  path: '/',
  waitOn: -> [
    Meteor.subscribe 'allStudents'
  ]
  cache: true

# Non-Administrative routes
  @route 'login',
  path: '/login'

  @route 'individual',
  path: '/individual/:_id',
  waitOn: -> [
    Meteor.subscribe 'findAllShiftsForStudent', Router?.current()?.params?._id
    Meteor.subscribe 'allStudents'
  ]
  cache: false

  @route 'publicstatistics',
  path: '/publicstatistics'

  @route 'exchange',
  waitOn: -> [
    Meteor.subscribe 'allShifts'
    Meteor.subscribe 'allStudents'
  ]
  path: '/exchange'

  @route 'acceptTrade',
  waitOn: ->
    Meteor.subscribe 'specificTrade', Router?.current()?.params?._id
  path: '/acceptTrade/:_id'

# Administrative routes
  @route 'backend', path: '/backend'

  @route 'users', path: '/users'

  @route 'privatestatistics', path: '/privatestatistics'

  @route 'shiftlist',
  path: '/shiftlist',
  waitOn: -> Meteor.subscribe 'allShifts',
  cache: false

  @route 'assignments',
  path: '/assignments',
  waitOn: -> [
    Meteor.subscribe 'allShifts'
    Meteor.subscribe 'allStudents'
  ]
  cache: false

  @route 'students',
  waitOn: -> [
    Meteor.subscribe 'allStudents'
  ]
  path: '/students'

  @route 'exemptions', path: '/exemptions'

  @route 'logs', path: '/logs'

  @route 'supervisor', path: '/supervisor'

  @route 'help', path: '/help'

  @route 'imprint', path: '/imprint'
  @route 'privacy', path: '/privacy'
  @route 'terms', path: '/terms'

### Require signing in for all routes, except:
Router.plugin 'ensureSignedIn',
  except: ['home', 'imprint', 'privacy', 'terms']
###

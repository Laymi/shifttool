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
  waitOn: ->
    Meteor.subscribe 'allShifts',
  cache: true
# Non-Administrative routes
  @route 'login', path: '/login'

  @route 'individual',
  path: '/individual/:_id',
  waitOn: -> Meteor.subscribe 'findAllShiftsForStudent', Router?.current()?.params?._id,
  cache: false

  @route 'publicstatistics', path: '/publicstatistics'

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
  waitOn: ->
    Meteor.subscribe 'allShifts',
  cache: false

  @route 'students', path: '/students'

  @route 'exemptions', path: '/exemptions'

  @route 'logs', path: '/logs'

  @route 'imprint', path: '/imprint'
  @route 'privacy', path: '/privacy'
  @route 'terms', path: '/terms'

### Require signing in for all routes, except:
Router.plugin 'ensureSignedIn',
  except: ['home', 'imprint', 'privacy', 'terms']
###

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
  waitOn: -> Meteor.subscribe 'allShifts',
  cache: true

  @route 'individual',
  path: '/individual/:_id',
  waitOn: -> Meteor.subscribe 'findAllShiftsForStudent', Router?.current()?.params?._id,
  cache: true

  @route 'publicstatistics', path: '/publicstatistics'
# Administrative routes
  @route 'backend', path: '/backend'
  @route 'privatestatistics', path: '/privatestatistics'
  @route 'shiftlist', path: '/shiftlist'
  @route 'assignments', path: '/assignments'
  @route 'students', path: '/students'
  @route 'exemptions', path: '/exemptions'
  @route 'logs', path: '/logs'

  @route 'imprint', path: '/imprint'
  @route 'privacy', path: '/privacy'
  @route 'terms', path: '/terms'

# Require signing in for all routes, except:
Router.plugin 'ensureSignedIn',
  except: ['home', 'imprint', 'privacy', 'terms']

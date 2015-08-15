Template.Header.helpers

  isActiveRoute: (name) ->
    if name is Router.current().route.getName() then 'active' else ''

  initLeanModal: ->
    instance = Template.instance()
    Meteor.defer ->
      instance.$('.modal-trigger').leanModal()


Template.Header.events

  'click #survey-create-modal a': (e, template) ->
    template.$('#survey-create-modal').closeModal()

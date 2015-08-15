Template.BirthdayInput.onRendered ->
  @$('#birthday-input').pickadate
    format: 'yyyy-mm-dd'
    selectMonths: true
    selectYears: 100
    max: new Date()
    today: false
    clear: false

# Routes
AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'enrollAccount'
AccountsTemplates.configureRoute 'forgotPwd'
AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'signIn'
AccountsTemplates.configureRoute 'signUp'
AccountsTemplates.configureRoute 'verifyEmail'

# Options
AccountsTemplates.configure
  showForgotPasswordLink: true
  overrideLoginErrors: true
  enablePasswordChange: true
  confirmPassword: false
  sendVerificationEmail: false
  negativeValidation: true
  positiveValidation: true
  negativeFeedback: false
  positiveFeedback: false
  homeRoutePath: '/'
  privacyUrl: 'privacy'
  termsUrl: 'terms'
  preSignUpHook: (password, info) ->
    info.profile.birthday = $('#birthday-input').val()

# Setup custom signup form

AccountsTemplates.removeField 'email'
AccountsTemplates.removeField 'password'

AccountsTemplates.addFields [
    _id: 'email'
    type: 'email'
    required: true
    displayName: 'Email'
    negativeValidation: true
    negativeFeedback: true
    errStr: 'Please enter a ".edu" email'
    func: (value) ->
      isValidEmail = SimpleSchema.RegEx.Email.test(value)
      isEduEmail = value.slice(-4) is '.edu'
      return not isValidEmail or not isEduEmail
  ,
    _id: 'password'
    type: 'password'
    required: true
    displayName: 'Password'
    minLength: 6
    errStr: 'Password must have at least 6 characters'
  ,
    _id: 'firstName'
    type: 'text'
    required: true
    displayName: 'First Name'
  ,
    _id: 'lastName'
    type: 'text'
    required: true
    displayName: 'Last Name'
  ,
    _id: 'birthday'
    type: 'text'
    displayName: 'Birthday'
    template: 'BirthdayInput'
  ,
    _id: 'gender'
    type: 'select'
    displayName: 'Gender'
    select: [
      text: 'Male'
      value: 'male'
    ,
      text: 'Female'
      value: 'female'
    ]
  ,
    _id: 'qualification'
    type: 'select'
    displayName: 'Qualification'
    select: [
      text: 'Secondary School'
      value: 'secondary_school'
    ,
      text: 'Graduate'
      value: 'graduate'
    ,
      text: 'Professional'
      value: 'professional'
    ]
  ,
    _id: 'organization'
    type: 'text'
    required: false
    displayName: 'Organization'
  ,
    _id: 'website'
    type: 'text'
    required: false
    displayName: 'Website'
  ,
    _id: 'country'
    type: 'select'
    displayName: 'Country'
    select: [
      # Add a full list of countries later
      text: 'America'
      value: 'america'
    ,
      text: 'Germany'
      value: 'germany'
    ]
]


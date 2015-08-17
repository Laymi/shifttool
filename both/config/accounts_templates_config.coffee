### Routes
#AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'enrollAccount'
#AccountsTemplates.configureRoute 'forgotPwd'
#AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'signIn'
#AccountsTemplates.configureRoute 'signUp'
#AccountsTemplates.configureRoute 'verifyEmail'

# Options
AccountsTemplates.configure
  showForgotPasswordLink: false
  overrideLoginErrors: true
  enablePasswordChange: false
  confirmPassword: false
  sendVerificationEmail: false
  negativeValidation: true
  positiveValidation: true
  negativeFeedback: false
  positiveFeedback: false
  homeRoutePath: '/'
  privacyUrl: 'privacy'
  termsUrl: 'terms'

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
]
###

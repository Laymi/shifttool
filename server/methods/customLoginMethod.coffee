exec = Npm.require('child_process').exec

Meteor.methods
  loginWithPAP: (user, pass) ->
    check user, String
    check pass, String
    runCommand = Meteor.bindEnvironment((error, stdout, stderr) ->
      if stdout.indexOf('Access-Accept') == -1
        console.log 'failed login attempt', user
      else
        if stdout.indexOf('Access-Accept') > -1
          console.log 'successful login attempt', user
          userEmail = user + '@whu.edu'
          if Meteor.users.find({'emails.0.address': userEmail}).count() > 0
            return true
          else
            Accounts.createUser
              username: user
              email : userEmail
              password : pass
            return true
      if error != null
        console.log 'exec error: ' + error
      return
    )
    query = "radtest -t pap "
    query += user
    query += " "
    query += pass
    query += " "
    query += process.env.PAPIP
    query += " "
    query += process.env.PAPPORT
    query += " "
    query += process.env.PAPSECRET

    exec(query, runCommand);

    return

module.exports = {
  servers: {
    one: {
      host: '46.101.175.126',
      username: 'root',
      // or leave blank for authenticate from ssh-agent
    }
  },

  meteor: {
    name: 'shifttool',
    path: '../',
    servers: {
      one: {},
    },
    buildOptions: {
      serverOnly: true,
    },
    env: {
      ROOT_URL: 'http://shift.whu.edu',
      MONGO_URL: 'mongodb://localhost/meteor',
    },
    docker: {
      // change to 'kadirahq/meteord' if your app is not using Meteor 1.4
      image: 'abernix/meteord:base',
    },
    deployCheckWaitTime: 60,

    // Show progress bar while uploading bundle to server
    // You might need to disable it on CI servers
    enableUploadProgressBar: false
  },

  mongo: {
    oplog: true,
    port: 27017,
    version: '3.4.1',
    servers: {
      one: {},
    },
  },
};

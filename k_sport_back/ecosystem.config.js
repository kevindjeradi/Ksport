module.exports = {
  apps : [{
    name: 'K Sports backend',
    script: 'server.js',
    watch: true,
    ignore_watch: ['images'],
    env: {
      NODE_ENV: 'development'
    },
    env_production: {
      NODE_ENV: 'production'
    }
  }]
};

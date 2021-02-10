'use strict'


const mongoose = require('mongoose')
const app = require('./app')
const config = require('./config')
mongoose.connect(config.db, (err, res) =>{
  if(err) {
    return console.log(`Could not connect to Mongo DB database: ${err}`)
  }
  console.log('Database connection established...')

  app.listen(config.port, () => {
    console.log((`API REST running on http://localhost:${config.port}`));

  })
})

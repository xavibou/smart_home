module.exports = {
  port: process.env.PORT || 80,
  db: process.env.MONGODB_URI || 'mongodb://localhost:27017/shop'
}

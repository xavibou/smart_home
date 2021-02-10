'use strict'

const express = require ('express')
const deviceLogic = require('../logic/device')
const actionLogic = require('../logic/action')
const api = express.Router()

// Device management endpoints
api.get('/device', deviceLogic.getDevices)
api.get('/device/:deviceId', deviceLogic.getDeviceById)
api.get('/device/deviceType/:deviceType', deviceLogic.getDevicesByType)
api.get('/device/room/:room', deviceLogic.getDevicesByRoom)
api.post('/device', deviceLogic.registerDevice)
api.put('/device/:deviceId', deviceLogic.updateDevice)
api.delete('/device/:deviceId', deviceLogic.deleteDevice)

// Device usage endpoints
api.get('/action', actionLogic.getActions)
api.get('/action/deviceId/:deviceId', actionLogic.getActionsByDeviceId)
api.get('/action/deviceType/:deviceType', actionLogic.getActionsByType)
api.get('/action/room/:room', actionLogic.getActionsByRoom)
api.post('/action', actionLogic.sendAction)
api.delete('/action/:actionId', actionLogic.deleteAction)

// Statistics ebdpoints
api.get('/stats/actions/month/:month/:year', actionLogic.getActionsByMonth)
api.get('/stats/actions/day/:day/:month/:year', actionLogic.getActionsByDay)
api.get('/stats/actions/lastWeek', actionLogic.getLastWeekActions)
api.get('/stats/deviceActions/month/:deviceId/:month/:year', actionLogic.getDeviceActionsByMonth)
api.get('/stats/deviceActions/day/:deviceId/:day/:month/:year', actionLogic.getDeviceActionsByDay)

module.exports = api

//
//  Device.swift
//  Home Automation App
//
//  Created by Xavier Bou on 4/7/20.
//  Copyright © 2020 Xavier Bou. All rights reserved.
//

import Foundation

struct Device: Codable {
    var _id: String?
    var name: String?
    var deviceType: String?
    var state: String?
    var room: String?
    var receivingTopic: String?
    var respondingTopic: String?
    init() {
        _id = nil
        name = nil
        deviceType = nil
        state = nil
        room = nil
        receivingTopic = nil
        respondingTopic = nil
    }
}

struct DevicesList: Codable {
    var device: [Device]?
}

struct SingleDevice: Codable {
    let device: Device?
    init() {
        device = nil
    }
}

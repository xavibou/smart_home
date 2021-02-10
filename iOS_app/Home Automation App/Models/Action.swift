//
//  Action.swift
//  Home Automation App
//
//  Created by Xavier Bou on 4/7/20.
//  Copyright © 2020 Xavier Bou. All rights reserved.
//

import Foundation

class Action: Codable {
    let _id: String?
    let deviceId: String?
    let newState: String?
    let deviceType: String?
    let room: String?
    let year: Int?
    let month: Int?
    let day: Int?
    let hour: Int?
}

struct ActionsList: Codable {
    let action: [Action]?
}




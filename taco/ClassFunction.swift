//
//  ClassFunction.swift
//  taco
//
//  Created by Franky Chainoor Johari on 13/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import Foundation

public let defaults = UserDefaults.standard

func GenerateUUID() -> String{
    let uuid = UUID().uuidString
    defaults.set(uuid, forKey: "UUID")
    return uuid
}

func memberID() -> String {
    let uuid = defaults.string(forKey: "UUID")!
    return uuid
}

func room_code() -> String {
      return defaults.string(forKey: "room_code")!
}


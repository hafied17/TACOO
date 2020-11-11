//
//  DataModel.swift
//  taco
//
//  Created by Franky Chainoor Johari on 10/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import Foundation

struct postDataTranscript: Encodable {
    var speakerID: String?
    var timestampStart: TimeInterval
    var duration: TimeInterval
    var timestampEnd: TimeInterval
    var text: String
}

struct postDataMeeting: Encodable {
    var fullTranscription = [postDataTranscript]()
}

struct StatusResponseJson: Encodable, Decodable {
    var status: Bool
    var description: String
}

struct DetailResult: Encodable, Decodable {
    var victim_name: String
    var number_interuption: Int8
}

struct Result: Encodable, Decodable {
    var total_terinterruptions: Int8
    var details = [DetailResult]()
}



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

struct JoinRoom: Codable {
    let status: Bool?
    let description: String?


    private enum CodingKeys: String, CodingKey{
        case status
        case description
    }
}

struct CreateRoom: Codable {
    let status: Bool?
    let description: String?
    let room_code: Int?
    
    private enum CodingKeys: String, CodingKey{
        case status
        case description
        case room_code
    }
}

struct DetailResult: Decodable {
    var victim_name: String?
    var number_interuption: Int?
    
    private enum CodingKeys: String, CodingKey{
        case victim_name
        case number_interuption
    }
}

struct Result: Decodable {
    var total_terinterruptions: Int
    var details: [DetailResult]?
    
    private enum CodingKeys: String, CodingKey{
        case total_terinterruptions
        case details
    }
}




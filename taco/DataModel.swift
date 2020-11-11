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

struct DetailResult: Decodable {
    var victim_name: String?
    var number_interuption: Int8?
    
    private enum CodingKeys: String, CodingKey{
        case victim_name
        case number_interuption
    }
}

struct Result: Decodable {
    var total_terinterruptions: Int8
    var details: [DetailResult]?
    
    private enum CodingKeys: String, CodingKey{
        case total_terinterruptions
        case details
    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do{
//            let detailsResult = try container.decode(DetailResult.self, forKey: .details)
//            details = [detailsResult]
//        }catch DecodingError.typeMismatch{
//            details = try container.decode([DetailResult].self, forKey: .details)
//        }
//    }

}




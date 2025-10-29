//
//  APODErrorModel.swift
//  APOD App
//
//  Created by Mohit Vegad on 26/10/2025.
//

import Foundation

struct APODErrorModel: Codable {
    
    let code: Int
    let message: String
    let serviceVersion: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
        case serviceVersion = "service_version"
    }
}

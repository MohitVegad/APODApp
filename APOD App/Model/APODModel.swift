//
//  APODModel.swift
//  APOD App
//
//  Created by Mohit Vegad on 26/10/2025.
//

import Foundation
import UIKit

struct APODModel: Codable {
    
    let date: String
    let explanation: String
    let hdUrl: String
    let mediaType: String
    let serviceVersion: String
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case explanation = "explanation"
        case hdUrl = "hdurl"
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title = "title"
        case url = "url"
    }
}

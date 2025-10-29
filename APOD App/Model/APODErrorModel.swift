//
//  APODErrorModel.swift
//  APOD App
//
//  Created by Mohit Vegad on 26/10/2025.
//

import Foundation

struct APODErrorModel: Codable {
    
    let code: Int
    let msg: String
    let service_version: String
}

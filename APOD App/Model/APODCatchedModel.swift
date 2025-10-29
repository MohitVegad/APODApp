//
//  APODCatchedModel.swift
//  APOD App
//
//  Created by Mohit Vegad on 28/10/2025.
//

import Foundation

import UIKit

struct CachedAPODModel {
    
    let apod: APODModel
    let isFromCache: Bool
    let cachedImage: UIImage?
}

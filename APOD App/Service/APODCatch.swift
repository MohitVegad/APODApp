//
//  APODCatch.swift
//  APOD App
//
//  Created by Mohit Vegad on 27/10/2025.
//

import UIKit
final class APODCache {

    static let shared = APODCache()
    
    private init() {}

    private let _apodCacheFolder = "APODCache"
    private let apodFileName = "lastAPODCatchedData.json"
    private let imageFileName = "lastAPODCatchedImageData.png"

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var cacheDirectory: URL {
           let url = documentsDirectory.appendingPathComponent(_apodCacheFolder)
           if !FileManager.default.fileExists(atPath: url.path) {
               try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
           }
           return url
       }

    // MARK: - SAVE CURRENT DATA
    
    func saveCurrentAPODData(apod: APODModel) {
        let apodURL = cacheDirectory.appendingPathComponent(apodFileName)
        if let data = try? JSONEncoder().encode(apod) {
            try? data.write(to: apodURL)
        }

        print("DOCUMENT DIRECTORY PATH=== \(documentsDirectory.path)")
    }


    // MARK: - LOAD PREVIOUS DATA
    
    func loadAPODData() -> APODModel? {
        let apodURL = cacheDirectory.appendingPathComponent(apodFileName)
        
        do {
            let data = try Data(contentsOf: apodURL)
            let apod = try JSONDecoder().decode(APODModel.self, from: data)
            return apod
        } catch {
            print("Failed to load APOD from disk: \(error)")
            return nil
        }
    }


    
    // MARK: - CLEAR CATCH
    
       func clearCache() {
           let fileManager = FileManager.default
           let contents = (try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)) ?? []

           for file in contents {
               try? fileManager.removeItem(at: file)
           }
       }
}

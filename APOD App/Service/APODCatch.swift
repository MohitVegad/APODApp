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
    
    func saveCurrentAPODData(apod: APODModel, image: UIImage?) {
        
        let apodURL = cacheDirectory.appendingPathComponent(apodFileName)
        if let data = try? JSONEncoder().encode(apod) {
            try? data.write(to: apodURL)
        }
        print("DOCUMENT DIRECTORY PATH : \(documentsDirectory.path())")
        guard let image = image else { return }
        let imageURL = cacheDirectory.appendingPathComponent(imageFileName)
        if let pngData = image.pngData() {
            try? pngData.write(to: imageURL)
        }
    }

    // MARK: - LOAD PREVIOUS DATA
    
    func loadAPODData() -> (APODModel, UIImage?)? {
        let apodURL = cacheDirectory.appendingPathComponent(apodFileName)
        let imageURL = cacheDirectory.appendingPathComponent(imageFileName)

        guard let data = try? Data(contentsOf: apodURL),
              let apod = try? JSONDecoder().decode(APODModel.self, from: data) else {
            return nil
        }

        let image = UIImage(contentsOfFile: imageURL.path)
        return (apod, image)
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

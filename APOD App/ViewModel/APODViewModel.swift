//
//  APODViewModel.swift
//  APOD App
//
//  Created by Mohit Vegad on 26/10/2025.
//

import Foundation


final class APODViewModel {
        
    private let apiService: APODApiService

    private(set) var apodModel: APODModel? {
        didSet {
            onUpdate?()
        }
    }
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(apiService: APODApiService = APODApiService.shared) {
        self.apiService = apiService
    }
    
    @MainActor
    func fetchAPOD(selectedDate: Date? = Date()) async {
        do {
            let apod = try await apiService.fetchAPOD(for: selectedDate)
            APODCache.shared.saveCurrentAPODData(apod: apod)
            self.apodModel = apod
            
        } catch {
            if let apod = APODCache.shared.loadAPODData() {
                self.apodModel = apod
            } else {
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    var titleText: String {
        apodModel?.title ?? kEmptyString
    }
    
    var dateText: String {
        apodModel?.date.formattedLongDate ?? kEmptyString
    }
    
    var explanationText: String {
        apodModel?.explanation ?? kEmptyString
    }
    
    private func loadImageData(for apod: APODModel) async -> Data? {
        if apod.mediaType == "image", let url = URL(string: apod.url) {
            return try? await URLSession.shared.data(from: url).0
        } else if apod.mediaType == "video",
                  let thumbnailURL = _getYoutubeThumbnailURL(from: apod.url) {
            return try? await URLSession.shared.data(from: thumbnailURL).0
        } else {
            return nil
        }
    }
    
    // MARK: - YouTube Thumbnail
      private func _getYoutubeThumbnailURL(from embedURL: String) -> URL? {
          guard let url = URL(string: embedURL) else { return nil }
          if url.host?.contains("youtube.com") == true, url.absoluteString.contains("embed/") {
              let components = url.absoluteString.components(separatedBy: "embed/")
              if components.count > 1 {
                  let videoID = components[1].components(separatedBy: "?")[0]
                  return URL(string: "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg")
              }
          }
          return nil
      }
}

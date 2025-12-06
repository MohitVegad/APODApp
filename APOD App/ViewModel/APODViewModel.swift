//
//  APODViewModel.swift
//  APOD App
//
//  Created by Mohit Vegad on 26/10/2025.
//

import Foundation


final class APODViewModel {
        
    private(set) var cachedAPOD: CachedAPODModel? {
        didSet {
            onUpdate?()
        }
    }
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    @MainActor
    func fetchAPOD(selectedDate: Date? = Date()) async {
        do {
            let apod = try await APODApiService.shared.fetchAPOD(for: selectedDate)
            self.cachedAPOD = CachedAPODModel(apod: apod, isFromCache: false, cachedImageData: nil)
        } catch {
            self.onError?(error.localizedDescription)
        }
    }
    
    var titleText: String {
        cachedAPOD?.apod.title ?? kEmptyString
    }
    
    var dateText: String {
        cachedAPOD?.apod.date.formattedLongDate ?? kEmptyString
    }
    
    var explanationText: String {
        cachedAPOD?.apod.explanation ?? kEmptyString
    }
    
    var imageData: Data? {
        cachedAPOD?.cachedImageData
    }
    
    private func loadImageData(for apod: APODModel, completion: @escaping (Data?) -> Void) {
         if apod.mediaType == "image", let url = URL(string: apod.url) {
             URLSession.shared.dataTask(with: url) { data, _, _ in
                 completion(data)
             }.resume()
         } else if apod.mediaType == "video", let thumbnailURL = _getYoutubeThumbnailURL(from: apod.url) {
             URLSession.shared.dataTask(with: thumbnailURL) { data, _, _ in
                 completion(data)
             }.resume()
         } else {
             completion(nil)
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

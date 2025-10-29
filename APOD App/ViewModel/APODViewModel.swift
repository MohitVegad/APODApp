//
//  APODViewModel.swift
//  APOD App
//
//  Created by Mohit Vegad on 26/10/2025.
//

import UIKit

final class APODViewModel {
        
    private(set) var cachedAPOD: CachedAPODModel? {
        didSet {
            onUpdate?()
        }
    }
    
    var _cachedImage: UIImage?
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchAPOD(selectedDate: Date? = Date()) {
        
        APODApiService.shared.fetchAPOD(for: selectedDate) { [weak self] (result: Result<APODModel, Error>) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let apod):
                    self?.loadImage(for: apod) { image in
                        let cached = CachedAPODModel(apod: apod,
                                                     isFromCache: false,
                                                     cachedImage: image)
                        
                        // SAVE DATA TO DOCUMENT DIRECTORY
                        APODCache.shared.saveCurrentAPODData(apod: apod, image: image)
                        self?.cachedAPOD = cached
                    }
                case .failure(let error):
                    if let (apod, image) = APODCache.shared.loadAPODData() {
                        let cached = CachedAPODModel(apod: apod, isFromCache: true, cachedImage: image)
                        self?.cachedAPOD = cached
                        print("===== APOD CACHED LOADED =====")
                    } else {
                        self?.cachedAPOD = nil
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
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
    
    var image: UIImage? {
        cachedAPOD?.cachedImage
    }

    
    private func loadImage(for apod: APODModel, completion: @escaping (UIImage?) -> Void) {
          if apod.mediaType == "image", let url = URL(string: apod.url) {
              URLSession.shared.dataTask(with: url) { data, _, _ in
                  completion(data.flatMap(UIImage.init))
              }.resume()
          } else if apod.mediaType == "video", let thumbnailURL = _getYoutubeThumbnailURL(from: apod.url) {
              URLSession.shared.dataTask(with: thumbnailURL) { data, _, _ in
                  completion(data.flatMap(UIImage.init))
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





//                    if let (cachedAPOD, cachedImage) = APODCache.shared.loadAPOD() {
//                        print("===== APOD CATCHED LOADED =====")
//                        self?.apod = cachedAPOD
//                        self?._cachedImage = cachedImage
////                        self?.apod?.isDataCatched = true
////                        self?.onUpdate?()
//                        return
//                    }
//                    self?.onError?(error.localizedDescription)
//                    self?.onUpdate?()
//                    print(" ==== API FAILED TO RESPONSE : \(error.localizedDescription)")


//    var dateText: String {
//        //        apod?.date ?? ""
//        guard let dateString = apod?.date else { return kEmptyString }
//
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = kFormatDate
//        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//        guard let date = inputFormatter.date(from: dateString) else {
//            return dateString
//        }
//
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateStyle = .long
//        outputFormatter.locale = Locale(identifier: "en_US")
//
//        return outputFormatter.string(from: date)
//    }
    
//    func loadImage(completion: @escaping (UIImage?) -> Void) {
//           guard let apod = apod else { completion(nil); return }
//
//           if apod.mediaType == "image", let url = URL(string: apod.url) {
//               URLSession.shared.dataTask(with: url) { data, _, _ in
//                   let image = data.flatMap(UIImage.init)
////                   let images = apod.isDataCatched ? self._cachedImage : image
//                   completion(image)
//               }.resume()
//
//           } else if apod.mediaType == "video" {
//               if let thumbnailURL = _getYoutubeThumbnailURL(from: apod.url) {
//                   URLSession.shared.dataTask(with: thumbnailURL) { data, _, _ in
//                       let image = data.flatMap(UIImage.init)
//                       completion(image)
//                   }.resume()
//               } else {
//                   completion(nil)
//               }
//           }
//       }

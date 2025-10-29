//
//  APODService.swift
//  APOD App
//
//  Created by Mohit Vegad on 26/10/2025.

import Foundation

final class APODApiService {
    
    static let shared = APODApiService()
    private init() {}
    
    //BASEURL
    private let _baseURL: String = "https://api.nasa.gov/planetary/apod"
    
    //PATAMETERS
    private let _apodApiKeyName: String = "api_key"
    private let _apodApiKeyValue: String = "UcnsxX2gV2HR4mm6mIXuvppFf7gRXqZdpouYas3q"
    
    func fetchAPOD(for date: Date?, completion: @escaping (Result<APODModel, Error>) -> Void) {
        
        var components = URLComponents(string: _baseURL)
        components?.queryItems = [URLQueryItem(name: _apodApiKeyName, value: _apodApiKeyValue)]
        
        if let date = date {
            let formatter = DateFormatter()
            print("CURRENT FETCHING DATA DATE : \(date)")
            formatter.dateFormat = kFormatDate
            components?.queryItems?.append(URLQueryItem(name: "date", value: formatter.string(from: date)))
        }
        
        guard let url = components?.url else { return }
        print("===APOD URL\(url)")
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let data = data,
                       let apiError = try? JSONDecoder().decode(APODErrorModel.self, from: data) {
                        completion(.failure(NSError(domain: "APODService", code: httpResponse.statusCode,userInfo: [NSLocalizedDescriptionKey: apiError.message])))
                    } else {
                        completion(.failure(NSError(domain: "APODService",code:httpResponse.statusCode,userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
                    }
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APODService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"])))
                return
            }
            
            do {
                let apod = try JSONDecoder().decode(APODModel.self, from: data)
                completion(.success(apod))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

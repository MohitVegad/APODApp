import Foundation

// MARK: - Typed Errors
import Foundation

// MARK: - Custom Errors
enum APODServiceError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case httpError(code: Int, message: String)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response."
        case .httpError(let code, let message):
            return "HTTP \(code): \(message)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

// MARK: - API Service
final class APODApiService {

    static let shared = APODApiService()
    private init() {}

    private let baseURL = "https://api.nasa.gov/planetary/apod"
    private let apiKey = "UcnsxX2gV2HR4mm6mIXuvppFf7gRXqZdpouYas3q"

    // ============================================================
    // MARK: - ASYNC/ AWAIT FETCH METHOD
    // ============================================================
    func fetchAPOD(for date: Date?) async throws -> APODModel {

        // Build URL
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]

        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            components?.queryItems?.append(
                URLQueryItem(name: "date", value: formatter.string(from: date))
            )
        }

        guard let url = components?.url else {
            throw APODServiceError.invalidURL
        }

        // Call API
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
            print("=====URL\(url)")
        } catch {
            throw APODServiceError.networkError(error)
        }

        // Validate HTTP response
        guard let http = response as? HTTPURLResponse else {
            throw APODServiceError.invalidResponse
        }

        // Check status code
        guard (200...299).contains(http.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APODErrorModel.self, from: data) {
                throw APODServiceError.httpError(code: http.statusCode, message: apiError.message)
            } else {
                throw APODServiceError.httpError(code: http.statusCode, message: "Unknown error.")
            }
        }

        do {
            return try JSONDecoder().decode(APODModel.self, from: data)
        } catch {
            throw APODServiceError.decodingError(error)
        }
    }
}

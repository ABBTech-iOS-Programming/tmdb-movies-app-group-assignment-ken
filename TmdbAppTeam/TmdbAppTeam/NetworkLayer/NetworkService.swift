//
//  NetworkService.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

import Foundation
protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class DefaultNetworkService:
    NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let createRequest = endpoint.makeRequest()
        
        switch createRequest {
        case .success(let urlRequest):
            do {
                let (data, response) = try await session.data(for: urlRequest)
                
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    guard (200...299).contains(statusCode) else {
                        throw NetworkError.serverError(statusCode: statusCode)
                    }
                }
                
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingError
                }
            } catch {
                throw error
            }
            
        case .failure(let error):
            throw error
        }
    }
    
    
    func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    
    
}

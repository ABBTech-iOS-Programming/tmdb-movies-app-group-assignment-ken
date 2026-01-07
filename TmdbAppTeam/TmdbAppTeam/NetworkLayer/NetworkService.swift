//
//  NetworkService.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

import Foundation
protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint, complation: @escaping (Result<T, NetworkError>) -> Void  )
}

final class DefaultNetworkService:
    NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, complation: @escaping (Result<T, NetworkError>) -> Void)  {
        
        let createRequest = endpoint.makeRequest()
        switch createRequest {
        case .success(let request):
            session.dataTask(with: request) {
                data, reponse, error in
                if let error {
                   return complation(.failure(.unknown(error)))
                }
                if let httpResponse = reponse as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    guard (200...299).contains(statusCode) else {
                        return complation(.failure(.serverError(statusCode: statusCode)))
                    }
                }
                
                guard let data else { return complation(.failure(.noData))}
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    complation(.success(decodedData))
                } catch {
                    complation(.failure(.decodingError))
            }
       
            }.resume()
            
        case .failure(let error):
            complation(.failure(error))
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

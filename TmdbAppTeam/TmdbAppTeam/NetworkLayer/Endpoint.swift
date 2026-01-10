//
//  Endpoint.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var httpBody: Encodable? { get }
}

extension Endpoint {
    func makeRequest() -> Result<URLRequest, NetworkError> {
        
        guard  var components = URLComponents(string: baseURL) else {
            return .failure(.invalidURL)
        }
        
        components.path += path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let httpBody {
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
            
            do{
                let encodingData = try JSONEncoder().encode(httpBody)
                request.httpBody = encodingData
            } catch {
                return .failure(.encodingError)
            }
        }
        return .success(request)
    }
}

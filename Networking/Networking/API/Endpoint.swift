//
//  Endpoint.swift
//  Networking
//
//  Created by Djuro on 12/13/20.
//

import Foundation

struct Endpoint {
    
    // MARK: - Properties
    var method: HttpMethod
    var path: String
    var queryItems = [URLQueryItem]()
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "my-json-server.typicode.com"
        components.path = "/typicode/demo/" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
    
    // MARK: - Initializer
    init(method: HttpMethod, path: String) {
        self.method = method
        self.path = path
    }
    
}

extension Endpoint {
    static var posts: Self {
        Endpoint(method: .get, path: "posts")
    }
}

extension URLSession {
    func request(_ endpoint: Endpoint, then completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: endpoint.url)
        
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = dataTask(with: request, completionHandler: completion)

        task.resume()
    }
    
    func request<T: Codable>(_ endpoint: Endpoint, then completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: endpoint.url)
        
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    print("Error: \(error)")
                }
            }
            
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let object = try decoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(object))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                print("Decoding error: \(error)")
            }
        }

        task.resume()
    }
}

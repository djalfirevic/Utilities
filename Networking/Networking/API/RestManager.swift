//
//  RestManager.swift
//  Networking
//
//  Created by Djuro on 12/13/20.
//

import UIKit
import Network

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class RestManager {
    
    // MARK: - Properties
    static let shared = RestManager()
    private let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
    private let basePath = "https://my-json-server.typicode.com/typicode/demo"
	private var isConnected = true
    
    // MARK: - Initializer
    private init() {
        configureNetworkMonitor()
    }
    
    // MARK: - Public API
    func hasInternetConnection() -> Bool {
        return isConnected
    }
	
    func GET<T: Codable>(from urlString: String, _ completion: @escaping (Result<T, Error>) -> Void) {
        if hasInternetConnection() {
            let fullPath = "\(basePath)\(urlString)"
            
            guard let encoded = fullPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) else {
                fatalError("🛑 URL not formed")
            }
            
            let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
            let request = configureRequest(for: url, method: .get)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        print("Error: \(error)")
                    }
                }
                
                // Data acquired
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
    
    // MARK: - Private API
    private func configureRequest(for url: URL, method: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
	
    private func configureNetworkMonitor() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
            } else {
				self.isConnected = false
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
}

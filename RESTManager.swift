import UIKit
import Network

// Enums
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class RESTManager {
    
    // MARK: - Properties
    static let shared = RESTManager()
    private let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
    private let basePath = "http://api.staging.stagedriving.com"
    var token = ""
    var includeAuthorization = false
    
    // MARK: - Initializer
    private init() {
        configureNetworkMonitor()
    }
    
    // MARK: - Public API
    func hasInternetConnection() -> Bool {
        let reachability = Reachability()
        
        return reachability!.isReachable
    }
 
    func POST<T: Codable>(from urlString: String, httpBody: Data?, completion: @escaping (_ object: T?, _ error: Error?) -> ()) {
        if hasInternetConnection() {
            let fullPath = "\(basePath)\(urlString)"

            guard let encoded = fullPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) else {
                fatalError("🛑 URL not formed")
            }
            
            let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
            let request = configureRequest(for: url, method: .post, httpBody: httpBody)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                        Logger.log(message: "Error = \(String(describing: error))", type: .debug)
                    }
                }
                
                // Data acquired
                do {
                    if let data = data {
                        print("RESPONSE: \(String(describing: String(data: data, encoding: .utf8)!))")
                        
                        let object = try JSONDecoder().decode(T.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion(object, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    
                    Logger.log(message: "Decoding error: \(error.localizedDescription)", type: .warning)
                }
            }
            
            task.resume()
        }
    }
    
    func GET<T: Codable>(from urlString: String, parameters: [String: String]?, completion: @escaping (_ object: T?, _ error: Error?) -> ()) {
        if hasInternetConnection() {
            let fullPath = "\(basePath)\(urlString)"
            
            guard let encoded = fullPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) else {
                fatalError("🛑 URL not formed")
            }
            
            let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
            let request = configureRequest(for: url, method: .get, parameters: parameters)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                        Logger.log(message: "Error = \(String(describing: error))", type: .debug)
                    }
                }
                
                // Data acquired
                do {
                    if let data = data {
                        print("RESPONSE: \(String(describing: String(data: data, encoding: .utf8)!))")
                        
                        let object = try JSONDecoder().decode(T.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion(object, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    
                    Logger.log(message: "Decoding error: \(error.localizedDescription)", type: .warning)
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - Private API
    private func configureRequest(for url: URL, method: HttpMethod, httpBody: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        
        var body: String?
        if let data = httpBody {
            body = String(data: data, encoding: .utf8)
        }
        
        print("REQUEST: \(url.absoluteString), BODY: \(body ?? "")")
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if token.count > 0 && includeAuthorization {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }
        
        return request
    }
    
    private func configureRequest(for url: URL, method: HttpMethod, parameters: [String: String]?) -> URLRequest {
        var request: URLRequest!
        
        if let parameters = parameters {
            var components = URLComponents(string: url.absoluteString)!
            components.queryItems = parameters.queryItems
            
            if let url = components.url {
                request = URLRequest(url: url)
                
                print("REQUEST: \(url.absoluteString)")
            }
        } else {
            request = URLRequest(url: url)
            
            print("REQUEST: \(url.absoluteString), PARAMETERS: \(parameters ?? [:])")
        }
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if token.count > 0 && includeAuthorization {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func configureNetworkMonitor() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No Internet connection.")
            }
            
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
}

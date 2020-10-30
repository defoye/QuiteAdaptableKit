//
//  URLSession+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import UIKit

public enum RequestStatus {
    case success
    case error
}

public protocol DataManagerProtocol {
    func dataTask<T : Decodable>(_ url: URL, _ completion: @escaping ((RequestStatus, T?) -> Void))
    func dataTask<T : Decodable>(_ request: URLRequest, _ completion: @escaping ((RequestStatus, T?) -> Void))
    func downloadImage(_ url: URL, contentMode: UIView.ContentMode, _ completion: @escaping ((UIImage?) -> Void))
    func downloadImage(from link: String, contentMode mode: UIView.ContentMode, _ completion: @escaping ((UIImage?) -> Void))
    func createRequest(_ urlString: String, _ parameters: [String: String]?, _ headers: [String: String]?) -> URLRequest
}

extension DataManagerProtocol {
    public func dataTask<T : Decodable>(_ url: URL, _ completion: @escaping ((RequestStatus, T?) -> Void)) {
        print("----------------------------------REQUEST START----------------------------------")
        URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            if let _ = error {
                completion(.error, nil)
            }
            
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success, decoded)
                } catch _ {

                }
            }
            
            completion(.error, nil)
        }.resume()
        print("----------------------------------REQUEST END------------------------------------")
    }
    
    public func dataTask<T : Decodable>(_ request: URLRequest, _ completion: @escaping ((RequestStatus, T?) -> Void)) {
        print("----------------------------------REQUEST START----------------------------------")
        print("Request: \(request)")
        URLSession.shared.dataTask(with: request) { (data, reponse, error) in
            if let _ = error {
                completion(.error, nil)
            }
            
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    print(decoded)
                    completion(.success, decoded)
                } catch let err {
                    print(err)
                    completion(.error, nil)
                }
            } else {
                completion(.error, nil)
            }
            print("----------------------------------REQUEST END------------------------------------")
        }.resume()
    }
    
    public func downloadImage(_ url: URL, contentMode: UIView.ContentMode, _ completion: @escaping ((UIImage?) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(nil)
                    return
            }
            completion(image)
        }.resume()
    }
    
    public func downloadImage(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, _ completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        downloadImage(url, contentMode: mode, completion)
        
    }
    
    public func createRequest(_ urlString: String, _ parameters: [String: String]?, _ headers: [String: String]?) -> URLRequest {
        var urlComponents = URLComponents(string: urlString)

        var queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }

        urlComponents?.queryItems = queryItems

        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}

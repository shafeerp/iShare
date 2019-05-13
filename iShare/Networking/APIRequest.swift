//
//  APIRequest.swift
//  iShare
//
//  Created by Shafeer Puthalan on 12/05/19.
//  Copyright © 2019 Shafeer Puthalan. All rights reserved.
//

import Foundation

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters : [String : String] { get }
}

enum RequestType : String {
    case get = "GET"
    case post = "POST"
}

extension APIRequest {
    
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError( )
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("", forHTTPHeaderField: "Authorization")
        return request
    }
}


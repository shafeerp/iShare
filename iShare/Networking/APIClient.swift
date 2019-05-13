//
//  APIClient.swift
//  iShare
//
//  Created by Shafeer Puthalan on 12/05/19.
//  Copyright © 2019 Shafeer Puthalan. All rights reserved.
//

import Foundation

class APIClient {
    private let baseURL = URL(string: Constants.Networking.BASE_URL)!
//    func send(apiRequest : APIRequest) {
//        let req = apiRequest.request(with: self.baseURL)
//        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
//            if error != nil {
//                print(error!)
//                return
//            }
//            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
//            print(json)
//
//        }
//        task.resume()
//    }
    
    func send<T:Codable>(apiRequest : APIRequest,completionHandler: @escaping (_ result: T?, _ error: Error?) -> Void){

        let req = apiRequest.request(with: self.baseURL)
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if error != nil {
                print(error!)
                completionHandler(nil,error)
                return
            }
            do{
                let model : T = try JSONDecoder().decode(T.self, from: data!)
                completionHandler(model, nil)
            }
            catch(let parsingError){
                completionHandler(nil,parsingError)
            }
        }
        task.resume()
    }
}

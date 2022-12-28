//
//  MyHTTP.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/23/22.
//

import Foundation


let backendURL = "http://18.219.18.132/"
//let backendURL = "http://localhost/"

func httpReq(method: String, body: String, route: String, onRes: @escaping (String) -> Void) -> Void {

    
    let url = URL(string: backendURL + route)!
    var req = URLRequest(url: url)
    req.httpMethod = method
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = body == "" ? Data() : (body.data(using: .utf8))!

    
    URLSession.shared.uploadTask(with: req, from: req.httpBody){ data, response, error in
        if let error = error {
            print("Error \(error)")
            return
        }
        
        if let data = data, let response = String(data: data, encoding: .utf8){
            onRes(response)
        }
    }.resume()
}


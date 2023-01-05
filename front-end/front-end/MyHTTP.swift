//
//  MyHTTP.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/23/22.
//

import Foundation


let backendURL = "http://18.219.18.132/"
//let backendURL = "http://localhost/"

func sanitizeRoute(route: String) -> String{
    return route.replacingOccurrences(of: " ", with: "%20")
}

func httpReq(method: String, body: String, route: String, onRes: @escaping (String) -> Void) -> Void {
    print("1 IS THIS SHIT EVEN RUNNING \(route)")
    let santizedRoute = sanitizeRoute(route: route)
    
    let url = URL(string: backendURL + santizedRoute)!
    var req = URLRequest(url: url)
    req.httpMethod = method
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = body == "" ? Data() : (body.data(using: .utf8))!
    print("2 IS THIS SHIT EVEN RUNNING \(route)")
    
    URLSession.shared.uploadTask(with: req, from: req.httpBody){ data, response, error in
        if let error = error {
            print("Error \(error)")
            return
        }
        
        if let data = data, let response = String(data: data, encoding: .utf8){
            print("3 IS THIS SHIT EVEN RUNNING \(route)")
            onRes(response)
        }
    }.resume()
}


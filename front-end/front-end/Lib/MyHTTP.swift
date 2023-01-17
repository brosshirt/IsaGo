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



// Takes req information, makes req, parses it into appropriate object (with error handling), and then calls onRes on the parsed response
func httpReq<T: Codable>(method: String, body: String, route: String, as type: T.Type, onRes: @escaping (T) -> Void){
    let santizedRoute = sanitizeRoute(route: route)
    
    let url = URL(string: backendURL + santizedRoute)!
    var req = URLRequest(url: url)
    req.httpMethod = method
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = body == "" ? Data() : (body.data(using: .utf8))! // I really ought to be able to just send the string as it is
    
    URLSession.shared.uploadTask(with: req, from: req.httpBody){ data, response, error in
        if let error = error {
            print("Error \(error)")
            return
        }
        
        if let data = data, let response = String(data: data, encoding: .utf8){
            if let res = parseResponse(response: response, as: T.self) {
                // this is overkill, I've yet to figure out how to handle this 'modifying objects from the background issue'
                // it makes the errors go away for now though
                DispatchQueue.main.async{
                    onRes(res)
                }
            } else if let res = parseResponse(response: response, as: ErrorResponse.self) {
                print(res.msg) // in the future we want to print out this error to the screen by modifying some state variable
            } else {
                print("Idek man the backend is sending me some nonsense")
            }
        }
        else{
            print("Response was bad, I dunno") // need to play around more and see what goes in here
        }
    }.resume()
}


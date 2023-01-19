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
    
    
    let cacheName = "\(method)-\(body)-\(route)"
    
    // check the cache first!
    let cachedData = Cache.instance.get(name: cacheName)
    if (cachedData != nil){ // cache hit!
        let response = String(data: cachedData!.data, encoding: .utf8)
        let res = parseResponse(response: response!, as: T.self)
        onRes(res!) // we can just unwrap this stuff because we know that these operations don't fail
        return
    }
    
    // cache miss
    
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
        // this seems weird we're transforming the response from data -> string -> T, why does it ever need to be a string?
        if let data = data, let response = String(data: data, encoding: .utf8){
            if let res = parseResponse(response: response, as: T.self) {
                Cache.instance.add(name: cacheName, data: CacheableData(data)) // we don't actually need the status in the cache
                onRes(res)
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

// gets the pdf from s3, this can be modified for other types of s3 data
func getPDF(className: String, lessonName: String, onRes: @escaping (Data) -> Void){
    
    let cacheName = "\(className)-\(lessonName)"
    
    // check the cache first!
    let cachedData = Cache.instance.get(name: cacheName)
    if (cachedData != nil){ // cache hit!
        onRes(cachedData!.data)
        return
    }
    
    // cache miss
    
    let url = URL(string: s3Url(class_name: className, lesson_name: lessonName))!
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data, error == nil {
            Cache.instance.add(name: cacheName, data: CacheableData(data))
            onRes(data)
        } else {
            // later on this needs to print something to the screen explaining the error by modifying some state variable
            print("Error fetching pdf data: \(error!)")
        }
    }.resume()
    
}

func s3Url(class_name:String, lesson_name: String) -> String {
    return sanitizeRoute(route: "https://s3.amazonaws.com/isago-lessons/\(class_name)/\(lesson_name).pdf")
}



//let url = URL(string: s3Url(class_name: lesson.class_name, lesson_name: lesson.lesson_name))!
//URLSession.shared.dataTask(with: url) { data, response, error in
//    if let data = data, error == nil {
//        pdfDocument = PDFDocument(data: data)!
//        isLoading = false
//    } else {
//        print("Error fetching pdf data: \(error!)")
//    }
//}.resume()


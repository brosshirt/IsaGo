//
//  Responses.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/23/22.
//

import Foundation


struct ClassesResponse: Codable {
    let status: Int
    let taking: [Class]
    let notTaking: [Class]
    
    init(status: Int, taking: [Class], notTaking: [Class]) {
        self.status = status
        self.taking = taking
        self.notTaking = notTaking
    }
}

func getClassesResponse(response:String) -> ClassesResponse{
    var classesResponse = ClassesResponse(status: 0, taking: [], notTaking: [])
    print(response)
    do {
        let newData = response.data(using: .utf8)!
        classesResponse = try decoder.decode(ClassesResponse.self, from: newData)
    }
    catch{
        print("Error converting response string to ClassesResponse")
    }
    return classesResponse
}


struct EmptyResponse: Codable {
    let status: Int
    
    init(status: Int) {
        self.status = status
    }
}

struct ErrorResponse: Codable {
    let status: Int
    let msg: String
    
    init(status: Int, msg: String) {
        self.status = status
        self.msg = msg
    }
}

func getEmptyResponse(response:String) -> EmptyResponse{
    var emptyResponse = EmptyResponse(status: 0)
    do {
        let newData = response.data(using: .utf8)!
        emptyResponse = try decoder.decode(EmptyResponse.self, from: newData)
    }
    catch{
        print("Error converting response string to EmptyResponse")
    }
    return emptyResponse
}

struct LecturesResponse: Codable {
    let status: Int
    let lectures: [Lecture]
    
    init(status: Int, lessons: [Lecture]) {
        self.status = status
        self.lectures = lessons
    }
}

func getLecturesResponse(response:String) -> LecturesResponse{
    var lecturesResponse = LecturesResponse(status: 0, lessons: [])
    do {
        let newData = response.data(using: .utf8)!
        lecturesResponse = try decoder.decode(LecturesResponse.self, from: newData)
    }
    catch{
        print("Error converting response string to LecturesResponse")
        print(error)
    }
    return lecturesResponse
}

struct LessonsResponse: Codable {
    let status: Int
    let lessons: [Lesson]
    
    init(status: Int, lessons: [Lesson]) {
        self.status = status
        self.lessons = lessons
    }
}

func getLessonsResponse(response:String) -> LessonsResponse{
    var lessonResponse = LessonsResponse(status: 0, lessons: [])
    do {
        let newData = response.data(using: .utf8)!
        lessonResponse = try decoder.decode(LessonsResponse.self, from: newData)
    }
    catch{
        print("Error converting response string to LecturesResponse")
        print(error)
    }
    return lessonResponse
}

// generic function for turning a response into the object we're looking for
// problem: returns nil under two conditions. 1: If the string isn't in JSON format. 2: If it doesn't match the object type
func parseResponse<T: Codable>(response: String, as type: T.Type) -> T? {
    guard let data = response.data(using: .utf8) else { return nil }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Error converting response string to \(T.self)")
        return nil
    }
}


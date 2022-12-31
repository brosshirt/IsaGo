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

struct LessonsResponse: Codable {
    let status: Int
    let lessons: [Lesson]
    
    init(status: Int, lessons: [Lesson]) {
        self.status = status
        self.lessons = lessons
    }
}

func getLessonsResponse(response:String) -> LessonsResponse{
    var lessonsResponse = LessonsResponse(status: 0, lessons: [])
    do {
        let newData = response.data(using: .utf8)!
        lessonsResponse = try decoder.decode(LessonsResponse.self, from: newData)
    }
    catch{
        print("Error converting response string to LessonsResponse")
        print(error)
    }
    return lessonsResponse
}

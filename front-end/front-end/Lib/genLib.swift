//
//  genLib.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import Foundation


extension String {
    func substring(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: end - start)
        return String(self[startIndex..<endIndex])
    }
}

// turns MWF-1330 into MWF-1:30
// turns MWF-0920 into MWF-9:20
func timeString(class_time: String) -> String{
    // it has everything to do with the stuff after the dash
    let scheduleComponents = class_time.split(separator: "-")
    let daysOfWeek = scheduleComponents[0]
    let time = scheduleComponents[1]
    var hour = Int(time.prefix(2)) // this casts it down to a single digit if it's less than 12
    let minute = time.suffix(2)
    
    if (hour! > 12){
        hour = hour! - 12
    }
    
    return "\(daysOfWeek)-\(hour!):\(minute)"
}

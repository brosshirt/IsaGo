//
//  NotificationManager.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/13/23.
//

import Foundation
import UserNotifications



// Incredibly verbose way of handling local notifications. Gets the job done.
class NotificationManager{
    static let instance = NotificationManager()
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options){ (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else{
                print("SUCCESS")
            }
        }
    }
    // takes a className and classTime and creates however many notification requests are needed
    func scheduleNotification(className: String, classTime: String){
        let content = UNMutableNotificationContent()
        content.title = "\(className) starting in 15 minutes!"
        content.subtitle = "Tap to quickly view today's summary"
        content.sound = .default
        
        let dateComponentsArray = dateComponents(from: classTime) // this is necessary because you need to split it based off days of the week

        for dateComponents in dateComponentsArray{
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: className + classTime, // requests for the same section has the same identifier
                content: content,
                trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("\(request.identifier) \(request.content.title) \(request.content.body)")
            }
        }

    }
    
    func removeNotification(className: String, classTime: String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [className + classTime])
    }
    
    // Turns MWF-1000 into three date component objects that represent weekly notifications at 9:45am on Monday, Wednesday, Friday
    func dateComponents(from schedule: String) -> [DateComponents] {
        let days = ["M": 2, "T": 3, "W": 4, "R": 5, "F": 6, "S": 7, "U": 1]
        let scheduleComponents = schedule.split(separator: "-")
        let daysOfWeek = scheduleComponents[0]
        let time = scheduleComponents[1]
        let hour = Int(time.prefix(2))
        let minute = Int(time.suffix(2))
        var weekdays = [Int]()
        daysOfWeek.forEach { day in
            if let dayInt = days[String(day)] {
                weekdays.append(dayInt)
            }
        }
        var dateComponentsArray = [DateComponents]()
        for day in weekdays {
            var dateComponents = DateComponents()
            dateComponents.weekday = day
            if (minute! < 15){
                dateComponents.hour = hour! - 1
                dateComponents.minute = minute! + 45
            }
            else{
                dateComponents.hour = hour
                dateComponents.minute = minute! - 15
            }
            dateComponentsArray.append(dateComponents)
        }
        return dateComponentsArray
    }
    
}

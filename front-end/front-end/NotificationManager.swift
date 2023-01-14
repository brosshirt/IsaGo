//
//  NotificationManager.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/13/23.
//

import Foundation
import UserNotifications

class NotificationManager{
    static let instance = NotificationManager()
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options){ (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            }else{
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification(className: String, classTime: String){
        let content = UNMutableNotificationContent()
        content.title = "Today's \(className) lecture starts in 15 minutes!"
        content.subtitle = "Tap to quickly view today's summary"
        content.sound = .default
        
        
        let dateComponents = dateComponents(from: classTime)
        
        for dateComponent in dateComponents{
            // we need to create the request, which means we need to create the trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
            let request = UNNotificationRequest(
                identifier: className + classTime,
                content: content,
                trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
        
        
        
        
        
    }
    
    func removeNotification(className: String, classTime: String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [className + classTime])
    }
    
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

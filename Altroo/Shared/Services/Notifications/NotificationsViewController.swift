//
//  NotificationsViewController.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 07/11/25.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        checkForPermission()
    }
    
    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Notifications already authorized")
                self.scheduleNotification()
                
            case .denied:
                print("User denied notifications")
                
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                    if didAllow {
                        self.scheduleNotification()
                    } else {
                        print("User denied notifications")
                    }
                }
            default:
                break
            }
        }
    }
    
    func scheduleNotification() {
        let identifier = "identifier-notification"
        
        let content = UNMutableNotificationContent()
        content.title = "Altroo"
        content.body = "Venha registrar seus cuidados no app!"
        content.sound = .default
        
        let hour = 24
        let minute = 47
        
        var dateComponents = DateComponents(calendar: .current, timeZone: .current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}

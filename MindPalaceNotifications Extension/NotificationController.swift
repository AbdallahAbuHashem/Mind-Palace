//
//  NotificationController.swift
//  MindPalaceNotifications Extension
//
//  Created by Abdallah Abuhashem on 4/24/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {
    var title: String?
    var message: String?
    var image: String?

    override var body: NotificationView {
        NotificationView(title: title,
                         message: message, image: image)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {        
        title = notification.request.content.title
        message = notification.request.content.body
        image = (notification.request.content.userInfo["team"] as! String)
        
    }
}

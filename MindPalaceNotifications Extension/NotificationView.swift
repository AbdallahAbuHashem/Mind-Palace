//
//  NotificationView.swift
//  MindPalaceNotifications Extension
//
//  Created by Abdallah Abuhashem on 4/24/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import SwiftUI

struct NotificationView: View {
    let title: String?
    let message: String?
    let image: String?
    
    init(title: String? = nil,
         message: String? = nil,
         image: String? = nil) {
        self.title = title
        self.message = message
        self.image = image
    }
    
    var body: some View {
        VStack {
            
            if true {
                Image(self.image ?? "packers").resizable().scaledToFit().clipShape(Circle())
                .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    
            }
            
            Text(title ?? "Unknown Landmark")
                .font(.headline)
            
            Divider()
            
            Text(message ?? "You are within 5 miles of one of your favorite landmarks.")
                .font(.caption)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}

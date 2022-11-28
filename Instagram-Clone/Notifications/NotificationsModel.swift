//
//  NotificationsModel.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 24/11/22.
//

import Foundation
import Firebase
enum NotificationType:Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String{
        
        switch self{
        case .like: return "liked your post"
        case .follow: return "started following you"
        case .comment: return "commented on your post"
            
        }
        
    }
    
}

struct Notification {
    let uid : String
    var postImageUrl: String?
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageUrl:String
    let username: String
    var userIsFollowed = false
    init(dictionary:[String:Any]){
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
    
}


struct NotificaitonViewModel{
    
    var notification: Notification
    
    init(notification:Notification) {
        self.notification = notification
    }
    var postImageUrl:URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    var profileImageUrl: URL?{
        return URL(string: notification.userProfileImageUrl)
    }
    
    var timestampString:String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(),to: Date())
        
    }
    
    var NoticationMessage:NSAttributedString{
        let username = notification.username
        let message = notification.type.notificationMessage
        let attributedText = NSMutableAttributedString(string: "\(username) ",attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message,attributes: [.font:UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "  \(timestampString ?? "")",attributes: [.font:UIFont.systemFont(ofSize: 12),.foregroundColor:UIColor.lightGray]))
        
        return attributedText
    }
    
    var shouldHidePostImage:Bool {
        return self.notification.type == .follow
    }
    
    var followButtonText:String {
        return notification.userIsFollowed ? "Following" : "Follow"
    }
    
    var followBottonBackgroundColor:UIColor {
        return notification.userIsFollowed ? .white : .systemBlue
        
    }
    
    var followBottonTextColor:UIColor{
        return notification.userIsFollowed ?.black : .white
    }
}

//
//  CommentModel.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 21/11/22.
//
import UIKit
import Foundation
import Firebase

struct Comment{
    let uid:String
    let username:String
    let profileImageUrl:String
    let timestamp:Timestamp
    let commentText:String
    
    init(dictionary:[String:Any]){
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImage"] as? String ?? ""
        self.commentText = dictionary["comment"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())

    }
    
}

struct CommentViewModel {
    
    private let comment : Comment
    
    var profileImageUrl : URL? {
        return URL(string: comment.profileImageUrl)
    }
    
    var username:String {
        return comment.commentText
    }
    
    var commentText: String{
        return comment.commentText
    }
    init(comment: Comment) {
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: "\(comment.username) ",attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: comment.commentText,attributes: [.font:UIFont.systemFont(ofSize: 14)]))
         return attributedString
                                    
    }
    func size(forWidth width:CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
}

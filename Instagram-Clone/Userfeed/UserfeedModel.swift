//
//  PostModel.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 11/11/22.
//

import UIKit


import Firebase

struct UserfeedModel{
    
    struct FetchResponse{
        struct postdata{
            var snapshot : DocumentSnapshot
            
        }
    }
    
    
    struct ViewModel {
         
        struct Post{
            var caption:String
            var likes:Int
            let imageurl:String
            let timestamp:Timestamp
            let ownerUid: String
            let postId:String
            let ownerImageUrl:String
            let ownerUsername:String
            var didLike = false
            
        }
        struct PostViewModel{
            var post:Post
            var imageUrl:URL?{
                return URL(string: post.imageurl)
            }
            var userprofileImageUrl:URL?{
                return URL(string: post.ownerImageUrl)
            }
            var username: String {
                return post.ownerUsername
            }
            var caption:String{
                post.caption
            }
            var likes:Int{
                post.likes
            }
            
            var likeButtonTintColor: UIColor{
                return post.didLike ? .red : .black
            }
            
            var likeButtonImage: UIImage {
                return post.didLike ? UIImage(named: "like_selected")! : UIImage(named: "like_unselected")!
            }
            
            var likesLabelText: String{
                if post.likes == 0{
                    return "Be the First to Like"
                }
                
               else if post.likes != 1 {
                    return "\(post.likes) likes"
                    
                }else {
                    return "\(post.likes) like"
                }
            }
            var timestampString:String? {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
                formatter.maximumUnitCount = 1
                formatter.unitsStyle = .full
                
                return formatter.string(from: post.timestamp.dateValue(),to: Date())
                
            }
            
            init(post: Post) {
                self.post = post
            }
            
        }
        
    }
    
}
extension UserfeedModel.ViewModel.Post{
    
    init(postId:String,dictionary:[String:Any]){
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["Likes"] as? Int ?? 100
        self.imageurl = dictionary["imageURl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.postId = postId
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
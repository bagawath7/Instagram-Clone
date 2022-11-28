//
//  CommentWorker.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 21/11/22.
//

import Foundation
import Firebase

struct CommentWorker{
    static func uploadComment(comment: String,postID:String, user:UserModel.ViewModel.User,completion:@escaping(FirestoreCompletion)){
        
        let data: [String:Any] = ["uid":user.uid
                                  ,"comment":comment,
                                  "timestamp":Timestamp(date: Date()),
                                  "username":user.username,
                                  "profileImage":user.profileImageUrl]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data,completion: completion)
        
        
        
        
    }
}

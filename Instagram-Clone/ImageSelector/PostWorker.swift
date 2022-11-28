//
//  PostWorker.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 11/11/22.
//

import Foundation
import UIKit
import Firebase
 
struct PostWorker{
    
    static func uploadPost(caption: String,image:UIImage,user:UserModel.ViewModel.User ,completion:@escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption":caption,
                        "timestamp":Timestamp(date: Date()),
                        "Likes":0,
                        "imageURl" : imageUrl,
                        "ownerUid":uid ,
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername" : user.username] as [String:Any]
            let docRef = COLLECTION_POSTS.addDocument(data: data,completion: completion)
            
            
            self.updateUserFeedAfterPost(postId: docRef.documentID)
            
        }
    }
    private static func updateUserFeedAfterPost(postId: String){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, error in
             
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            
            COLLECTION_USERS.document(uid).collection("user-feed").document(postId).setData([:])
        }
    }
    
}

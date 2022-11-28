//
//  ProfileHelper.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 10/11/22.
//

import Foundation
import Firebase
typealias FirestoreCompletion = (Error?) ->Void


struct ProfileWorker{
    
    
    
    static func follow(uid: String, completion: @escaping (FirestoreCompletion)) {
        if let currentUid = Auth.auth().currentUser?.uid{
            COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]){_ in
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:],completion: completion)
            }
        }
        
        
    }
    
    static func unfollow(uid: String, completion: @escaping (FirestoreCompletion)) {
        
        if let currentUid = Auth.auth().currentUser?.uid{
            COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete{_ in
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
            }
        }
        
    }
    
    static func checkIfUserIsFollowed(uid:String,completion:@escaping(Bool)->Void){
        guard let currentUid = Auth.auth().currentUser?.uid else{return}
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else{return}
            completion(isFollowed)
        }
    }
    
    
    static func fetchPost(withPost postId: String,completion:@escaping(UserfeedModel.ViewModel.Post)->Void) {
        COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else{return}
            let post = UserfeedModel.ViewModel.Post(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    
    static func fetchFeedPosts(comepletion:@escaping([UserfeedModel.ViewModel.Post])->Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var posts = [UserfeedModel.ViewModel.Post]()
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            if snapshot.isEmpty {
                comepletion(posts)
            }
            else{
                snapshot.documents.forEach({ document in
                    fetchPost(withPost: document.documentID) { post in
                        posts.append(post)
                        posts.sort { $0.timestamp.seconds > $1.timestamp.seconds
                        }
                        comepletion(posts)
                    }
                })
            }
        }
    }
    
    static func updateUserFeedAfterFollowing(user:UserModel.ViewModel.User,didFollow:Bool){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user.uid)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            
            let docIDs = documents.map({$0.documentID})
            docIDs.forEach { id in
                if didFollow{
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).setData([:])
                }else{
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).delete()
                }
            }
        }
    }
    
   
    
    
}

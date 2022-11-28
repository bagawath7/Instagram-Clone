//
//  UserfeedWorer.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 14/11/22.
//

import Foundation
import Firebase

struct UserfeedWorker{
    
    static func fetchuser(withUid uid :String,completion:@escaping(UserModel.ViewModel.User)->Void) {
      
        COLLECTION_USERS.document(uid).getDocument{ snapshot,error in
            if let snapshot = snapshot {
                if let dictionary = snapshot.data(){
                    let user = UserModel.ViewModel.User(dictionary: dictionary)
                    completion(user)
                }
            }
            
        }
    }
    static func fetchPosts(completion:@escaping([UserfeedModel.ViewModel.Post])->Void){
        
        COLLECTION_POSTS.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            
            let posts = documents.map { UserfeedModel.ViewModel.Post(postId: $0.documentID, dictionary: $0.data())
                                                                     
            }
            completion(posts)
        }
    }
    
    
    static func likePost(post: UserfeedModel.ViewModel.Post,completion: @escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["Likes":post.likes + 1])
    
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:],completion: completion)
        }
    }
    
    static func unlikePost(post: UserfeedModel.ViewModel.Post,completion: @escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else {return}
        
        COLLECTION_POSTS.document(post.postId).updateData(["Likes":post.likes - 1])
    
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete{ _ in
            
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
        
    }
    
}

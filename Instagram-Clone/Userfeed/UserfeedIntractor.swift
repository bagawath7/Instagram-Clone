//
//  UserfeedIntractor.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 11/11/22.
//

import Foundation
import Firebase
protocol UserfeedBussinessLogic:AnyObject{
    
    func fetchPosts()
    func checkIfUserLikedPost(post:UserfeedModel.ViewModel.Post)
    
}
 
class UserfeedIntractor:UserfeedBussinessLogic{
    
    
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
    
    func checkIfUserLikedPost(post: UserfeedModel.ViewModel.Post) {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { snapshot, _ in
            if let snapshot = snapshot{
                self.presenter.presentLikes(snapshot: snapshot,post:post)
            }
        }
        
    }
    

        
    
    var presenter:UserfeedPresentationLogic!  
}

//
//  UserfeedIntractor.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 11/11/22.
//

import Foundation
import Firebase
protocol UserfeedBussinessLogic:AnyObject{
    
    func checkIfUserLikedPost(post:UserfeedModel.ViewModel.Post)
    func fetchFeedPosts()
    
}
 
class UserfeedIntractor:UserfeedBussinessLogic{
    
    var presenter:UserfeedPresentationLogic?
    
    
    func checkIfUserLikedPost(post: UserfeedModel.ViewModel.Post) {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { snapshot, _ in
            if let snapshot = snapshot{
                let response = UserfeedModel.FetchResponse.postdata(snapshot: snapshot)
                self.presenter?.presentLikes(snapshot: response,post:post)
            }
        }
        
    }
    
    
    
    
    func fetchFeedPosts(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        //        var posts = [UserfeedModel.ViewModel.Post]()
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            var postSnapshots = [UserfeedModel.FetchResponse.postdata]()
            snapshot.documents.forEach({ document in
                self.fetchPost(withPost: document.documentID) { postSnapshot in
                    
                    let snapshot = UserfeedModel.FetchResponse.postdata(snapshot: postSnapshot)
                    postSnapshots.append(snapshot)
                    self.presenter?.presentPosts(snapshot: postSnapshots)
                    
                                          
                                        
                }
                

            })
        }
    }
    
     func fetchPost(withPost postId: String,completion: @escaping (DocumentSnapshot) -> Void) {
         COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
             if let snapshot = snapshot {
                 completion(snapshot)
             }
         }
        }
    }
    

    

    
 
    
        

        
    

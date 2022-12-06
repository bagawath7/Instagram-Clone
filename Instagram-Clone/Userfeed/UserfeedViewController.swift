//
//  UserfeedViewController.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 28/10/22.
//

import UIKit
import Firebase

protocol UserfeedDisplayLogic:AnyObject{
    func update(posts:[UserfeedModel.ViewModel.Post])
    func updateLikes(isLiked:Bool,post:UserfeedModel.ViewModel.Post)
}

private let reuseIdentifier = "Cell"

class UserfeedViewController: UICollectionViewController {
    
    var intractor:UserfeedBussinessLogic?
    
    private var posts = [UserfeedModel.ViewModel.Post](){
        didSet{
            collectionView.reloadData()
        }
    }
    var post: UserfeedModel.ViewModel.Post?{
        didSet{
            collectionView.reloadData()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        fetchPosts()
        configureUI()
        collectionView.backgroundColor = .white
        checkIfUserIsLoggedIn()
        checkIfUserLikedPost()
        
        navigationController?.view.tintColor = .black
        
   
        // Register cell classes
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       fetchPosts()
//        collectionView.reloadData()
    }
    
    
    func fetchPosts(){
        guard post == nil
        else {
            self.collectionView.refreshControl?.endRefreshing()
            return}
        
        
        intractor?.fetchFeedPosts()
    }
    
    func setup(){
        
        let intractor = UserfeedIntractor()
        let presenter = UserfeedPresenter()
        
        intractor.presenter = presenter
        self.intractor = intractor
        presenter.viewcontroller = self
    }
    
    
    func configureUI(){
        self.navigationController?.navigationBar.isTranslucent = false
        collectionView.backgroundColor = .white
        
        navigationItem.title = "Feed"
        
        navigationController?.view.tintColor = .black
        
        
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
        
    }
    
    @objc func handleRefresh(){
        posts.removeAll()
        fetchPosts()
    }
    
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let controller = LoginViewController()
                controller.delegate = self.tabBarController as! MainTabController
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: true)
            }
          
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = post{
            cell.viewModel = UserfeedModel.ViewModel.PostViewModel(post: post)
        }else{
            cell.viewModel = UserfeedModel.ViewModel.PostViewModel(post: posts[indexPath.row])
            }
        return cell
    }
    

}

extension UserfeedViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 110
        
        
        
        return CGSize(width: view.frame.width, height: height)
    }
        
        
    }

extension UserfeedViewController:UserfeedDisplayLogic{
    func updateLikes(isLiked: Bool, post: UserfeedModel.ViewModel.Post) {
        if self.post != nil{
            self.post?.didLike = isLiked
        }else{
            if let index = self.posts.firstIndex(where: { $0.postId == post.postId}){
                
                self.posts[index].didLike = isLiked
                
            }
            }
       
    }
    
    
    func update(posts: [UserfeedModel.ViewModel.Post]) {
        self.posts = posts
        collectionView.refreshControl?.endRefreshing()
        checkIfUserLikedPost()
        self.collectionView.reloadData()
        
    }
    
    func checkIfUserLikedPost(){
        
        
        
        if let post = post{
            intractor?.checkIfUserLikedPost(post: post)
        }else{
            
            
            posts.forEach { post in
                intractor?.checkIfUserLikedPost(post: post)
            }
            
        }
    }
}

//MARK: - FeedCellDelegate

extension UserfeedViewController:FeedCellDelegate{
    func cell(_ cell: FeedCell, wantstoShowProfileFor uid: String) {
        
        UserfeedWorker.fetchuser(withUid: uid) { user in
            let controller = ProfileViewController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
       
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: UserfeedModel.ViewModel.Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell:FeedCell,didLikePost post:UserfeedModel.ViewModel.Post){
        
        guard let tab = tabBarController as? MainTabController else {return}
        guard let user = tab.user else {return}
        
        
        cell.likeButton.isEnabled = false
        cell.viewModel?.post.didLike.toggle()
        if post.didLike{
            UserfeedWorker.unlikePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(named:"like_unselected"),for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
                cell.likeButton.isEnabled = true

                

            }
            
        }else{
            UserfeedWorker.likePost(post: post) { error in
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                cell.likeButton.isEnabled = true
                
             
                NotificatonWorker.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like,post: post)
            }
        }
    
    }

    
    
}

//
//  CommentController.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 15/11/22.
//

import UIKit

protocol CommentDisplayLogic:AnyObject{
    func update(comments:[Comment])
    
}

private let reuseIdentifier = "CommentCell"
class CommentController: UICollectionViewController ,CommentDisplayLogic{
    func update(comments: [Comment]) {
        
        for comment in comments {
            self.comments.append(comment)
        }
        
        self.collectionView.reloadData()
    }
    
    
    
    
    
    //MARK: Propertiea
    
    var comments = [Comment]()
    
    var intractor:CommentBusinessLogic!
    
    private let post: UserfeedModel.ViewModel.Post
    
    private lazy var customInputView: CommentInputView = {
        let iv = CommentInputView(frame: CGRect(x: 0, y: 0,
                                                        width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    init(post:UserfeedModel.ViewModel.Post){
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureCollectionView()

    }
    
    
    func setup(){
        
        let intractor = CommentIntractor()
        let presenter = CommentPresenter()
        
        intractor.presenter = presenter
        self.intractor = intractor
        presenter.viewcontroller = self
        
        
        
        intractor.fetchComments(forPost: post.postId )

        
    }
    
    
    
    override var inputAccessoryView: UIView?{
        get{ return customInputView  }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false

    }
    
    func  configureCollectionView(){
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
}

//MARK: - UICollectionViewDataSource
extension CommentController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])

        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CommentController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }
}


    
    
extension CommentController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputView, wantsToUploadComment message: String) {
        
        guard let tab = self.tabBarController as?MainTabController else{return}
        guard let user = tab.user else {return}
        self.showloader(true)
        CommentWorker.uploadComment(comment: message, postID: post.postId, user: user) { error in
            self.showloader(false)
            inputView.clearMessageText()
            NotificatonWorker.uploadNotification(toUid: self.post.ownerUid, fromUser: user, type: .comment,post: self.post)
        }
    }
}

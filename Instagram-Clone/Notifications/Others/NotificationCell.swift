//
//  NoticationCell.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 24/11/22.
//

import UIKit

protocol NotificationCellDelegate: AnyObject{
    
    func cell(_ cell:NotificationCell,wantsToFollow uid: String)
    func cell(_ cell:NotificationCell,wantsToUnfollow uid: String)
    func cell(_ cell:NotificationCell,wantsToViewPost PostId: String)


    
}


class NotificationCell: UITableViewCell {

    //MARK: - Properties
    
    
    var viewmodel: NotificaitonViewModel?{
        didSet{
            configure()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
        
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var postImageView: UIImageView  = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)

        
        return iv
    }()
    
    lazy var followButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48/2
        profileImageView.centerY(inView: self,leftAnchor: leadingAnchor,paddingLeft: 12)
        
        
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: trailingAnchor,paddingRight: 12,width: 88,height: 32)
        
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: trailingAnchor,paddingRight: 12,width: 40,height: 40)
        
        
        contentView.addSubview(infoLabel)
               infoLabel.centerY(inView: profileImageView,leftAnchor:profileImageView.trailingAnchor,paddingLeft: 8)
        infoLabel.anchor(right: followButton.leadingAnchor,paddingRight: 4)
        
        followButton.isHidden =  true
        
        

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    @objc func handleFollowTapped(){
        guard let viewmodel = viewmodel else {return}
        if viewmodel.notification.userIsFollowed{
            delegate?.cell(self, wantsToFollow: viewmodel.notification.uid )
        }else{
            delegate?.cell(self, wantsToUnfollow: viewmodel.notification.uid)
        }
        
            
    }
    
    @objc func handlePostTapped(){
        guard let postId = viewmodel?.notification.postId  else {return}
        delegate?.cell(self, wantsToViewPost: postId)
    }
    
    func configure(){
        guard let viewmodel = viewmodel else {return}
        
        postImageView.isHidden = viewmodel.shouldHidePostImage
        profileImageView.sd_setImage(with: viewmodel.profileImageUrl)
        postImageView.sd_setImage(with: viewmodel.postImageUrl)
        infoLabel.attributedText = viewmodel.NoticationMessage
        
        followButton.isHidden = !viewmodel.shouldHidePostImage
        
        followButton.setTitle(viewmodel.followButtonText, for: .normal)
        followButton.backgroundColor = viewmodel.followBottonBackgroundColor
        followButton.setTitleColor(viewmodel.followBottonTextColor, for: .normal)  
    }

}

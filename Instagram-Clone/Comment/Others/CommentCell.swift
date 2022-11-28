//
//  CommentCell.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 16/11/22.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    
    //MARK: Properties
    
    var viewModel: CommentViewModel?{
        didSet{
            configure()
        }
    }
    
    private let profileImageView:UIImageView = {
       
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
        
    }()
    
    private let commentLabel:UILabel = {
       let label = UILabel()
//        let attributedString = NSMutableAttributedString(string: "Gopal ",attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
//        attributedString.append(NSAttributedString(string: "some comment text is displayed here",attributes:[.font:UIFont.systemFont(ofSize: 14)]))
//        label.attributedText = attributedString
        
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        //MARK: ProfileImageView
        addSubview(profileImageView)
        profileImageView.centerY(inView: self,leftAnchor: leadingAnchor,paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        
        //MARK: CommentLabel
        addSubview(commentLabel)
        commentLabel.numberOfLines = 0
        commentLabel.centerY(inView: profileImageView)
        commentLabel.anchor(left: profileImageView.trailingAnchor,right:trailingAnchor,paddingLeft: 8,paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure(){
        
        guard let viewModel = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = viewModel.commentLabelText()
    }
    
    
}

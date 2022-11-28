//
//  CommentInputView.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 16/11/22.
//
import UIKit

protocol CustomInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputView, wantsToUploadComment message: String)
}

class CommentInputView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private lazy var CommentInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: trailingAnchor, paddingTop: 4, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(CommentInputTextView)
        CommentInputTextView.anchor(top: topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor,
                                    right: postButton.leadingAnchor, paddingTop: 12, paddingLeft: 4,
                                    paddingBottom: 8, paddingRight: 8)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(left: CommentInputTextView.leadingAnchor, paddingLeft: 4)
        placeholderLabel.centerY(inView: CommentInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !self.CommentInputTextView.text.isEmpty
    }
    
    @objc func handleComment() {
        guard let comment = CommentInputTextView.text else { return }
        delegate?.inputView(self, wantsToUploadComment: comment)
    }
    
    // MARK: - Helpers
    
    func clearMessageText() {
        CommentInputTextView.text = nil
        placeholderLabel.isHidden = false
    }
}

//
//  InputTextView.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 11/11/22.
//

import UIKit

class InputTextView: UITextView {
    
    //MARK: Properties
    
    var placeholderText: String?{
        didSet{
            placeholderLabel.text = placeholderText
        }
    }
    
     let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placeholderShouldCenter = true{
        didSet{
            
            if placeholderShouldCenter{
                placeholderLabel.anchor(left: leadingAnchor,right: trailingAnchor,paddingLeft: 8)
                placeholderLabel.centerY(inView: self)
            }else{
                placeholderLabel.anchor(top: topAnchor,left: leadingAnchor,paddingTop: 6,paddingLeft: 8)

            }
        }
    }
    
    //MARK: LifeCycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        
       NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
     
    @objc func handleTextDidChange(){
        placeholderLabel.isHidden = !text.isEmpty
    }
     
}

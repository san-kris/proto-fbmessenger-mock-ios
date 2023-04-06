//
//  FriendCell.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/5/23.
//

import UIKit

class FriendCell: UICollectionViewCell {
    
    let profileImageWidthHeight: CGFloat = 70
    
    let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile name goes here. This is a very long name"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.backgroundColor = .orange
        label.numberOfLines = 1
        return label
    }()
    
    let messageTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:00 AM"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.backgroundColor = .yellow
        label.textAlignment = .right
        return label
    }()
    
    lazy var profileNameStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileNameLabel, messageTimeLabel])
        sv.axis = .horizontal
        return sv
    }()
    
    let profileMessagePreviewLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friends message goes here. Bla Bla blah blah Bla this is too long... "
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.backgroundColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    let friendProfileIconImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icons8-heart-suit-96"))
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    lazy var friendProfileImageStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [UIView(), friendProfileIconImageView])
        sv.axis = .vertical
        return sv
    }()
    
    lazy var profileMessagePreviewStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileMessagePreviewLabel, friendProfileImageStackView])
        sv.axis = .horizontal
        return sv
    }()
    
    
    lazy var nameMessageStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileNameStackView, profileMessagePreviewStackView, UIView()])
        sv.spacing = 8
        sv.axis = .vertical
        return sv
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Background-Euro"))
        iv.contentMode = .scaleToFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = profileImageWidthHeight / 2
        return iv
    }()
    
    let messengerIconImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icons8-heart-suit-96"))
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    lazy var  dividerLineView: UIView = {
        let view = UIView()
        // view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() -> Void {
        addSubview(profileImageView)
        addSubview(messengerIconImageView)
        addSubview(nameMessageStackView)
        addSubview(dividerLineView)
        
        setupLayout()
    }
    
    func setupLayout() -> Void {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageWidthHeight).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1).isActive = true
        
        messengerIconImageView.translatesAutoresizingMaskIntoConstraints = false
        messengerIconImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0).isActive = true
        messengerIconImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 0).isActive = true
        messengerIconImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        messengerIconImageView.heightAnchor.constraint(equalTo: messengerIconImageView.widthAnchor, multiplier: 1).isActive = true
        
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        dividerLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        dividerLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: profileImageWidthHeight + 12).isActive = true
        // Do not use width anchor. It fixes the width to portrait width or landscape. Use Trailing anchor instead
        dividerLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        nameMessageStackView.translatesAutoresizingMaskIntoConstraints = false
        nameMessageStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        nameMessageStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        nameMessageStackView.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0).isActive = true
//        nameMessageStackView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0).isActive = true
        
        messageTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        messageTimeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        friendProfileIconImageView.translatesAutoresizingMaskIntoConstraints = false
        friendProfileIconImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        friendProfileIconImageView.heightAnchor.constraint(equalTo: friendProfileIconImageView.widthAnchor, multiplier: 1).isActive = true
        
        // calculating height of descripton lable dynamically
        let text = profileMessagePreviewLabel.text
        let boundingRect = NSString(string: text!).boundingRect(with: CGSize(width: frame.width - 120, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil, context: nil)
            
        print(boundingRect)
        print(frame.width)
        
        var descLabelHeight = boundingRect.height
        
        if boundingRect.height > 14 {
            descLabelHeight = 35
        }
        
        
        profileMessagePreviewLabel.translatesAutoresizingMaskIntoConstraints = false
        profileMessagePreviewLabel.heightAnchor.constraint(equalToConstant: descLabelHeight).isActive = true
        
    }
    
}

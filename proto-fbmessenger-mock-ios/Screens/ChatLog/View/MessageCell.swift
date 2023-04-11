//
//  MessageCell.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/8/23.
//

import UIKit

class MessageCell: UICollectionViewCell{
    
    var messageLabelLeadingConstraint: NSLayoutConstraint?
    var messageLabelTrailingConstraint: NSLayoutConstraint?
    
    var message: MessageCD? {
        didSet{
            guard let message else {return}
            print("Message set in cell. FromSender: \(message.fromSender); Text: \(message.text!)")
            messageLabel.text = message.text!
            senderBubbleAlignment()
        }
    }
    
    let profileImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Background-Euro"))
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        return iv
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Message Goes here"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.frame = CGRect(x: 0, y: 0, width: 250, height: frame.height)
        return label
    }()
    
    var messageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Message Cell DeInit Called")
    }
    
    func setupView() -> Void {
        addSubview(profileImage)
        addSubview(messageBackground)
        addSubview(messageLabel)
        
        setupLayout()
    }
    
    func setupLayout() -> Void {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: 1).isActive = true
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabelLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 7)
        messageLabelTrailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true

        messageBackground.translatesAutoresizingMaskIntoConstraints = false
        messageBackground.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -4).isActive = true
        messageBackground.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 4).isActive = true
        messageBackground.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -4).isActive = true
        messageBackground.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4).isActive = true
        
        senderBubbleAlignment()
    }
    
    func senderBubbleAlignment() -> Void {
        if let fromSender = message?.fromSender, fromSender{
            // Message is from sender
            messageLabelLeadingConstraint?.isActive = false
            messageLabelTrailingConstraint?.isActive = true
            // Hide image
            profileImage.isHidden = true
            messageBackground.backgroundColor = .lightGray
            messageLabel.textColor = .black
        } else {
            // Message is from friend
            messageLabelLeadingConstraint?.isActive = true
            messageLabelTrailingConstraint?.isActive = false
            // Display image
            profileImage.isHidden = false
            messageBackground.backgroundColor = .orange
            messageLabel.textColor = .white
        }
    }
    
}

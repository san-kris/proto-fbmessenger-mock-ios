//
//  ViewController+Extension.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/6/23.
//

import Foundation

extension FriendsController{
    
    func setupDummyData() -> Void {
        var friend = FriendProfile()
        friend.name = "John Smith"
        friend.profileImageName = "confused"
        
        var message = Message()
        message.text = "Hello"
        message.date = Date()
        message.friend = friend
        
        messages.append(message)
        
        friend = FriendProfile()
        friend.name = "Dan Boy"
        friend.profileImageName = "icons8-jack-o-lantern-96"
        
        message = Message()
        message.text = "Its halloween. Time to get some candy. this is meant to be a long message. Your friends message goes here. Bla Bla blah blah Bla this is too long... "
        message.date = Date()
        message.friend = friend
        
        messages.append(message)
        
        
    }
    
}

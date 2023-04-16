//
//  ViewController+Extension.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/6/23.
//

import UIKit
import CoreData

extension FriendsController{
    
    func setupDummyCoreData(){
        // delete all data from CD
        clearDataFromCD()
        
        // Get shared delegate from UIApplicatioon
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        // Get ViewContext from App Delegate -> Persistant Container
        if let context = delegate?.persistentContainer.viewContext{
            // Create a instance of CD class attached to context
            let friend = FriendCD(context: context)
            friend.setValuesForKeys([#keyPath(FriendCD.name) : "John Smith",
                                     #keyPath(FriendCD.profilePicture) : "confused"])
            
            _ = FriendsController.createMessageWithText(text: "Hello", from: friend, minutesAgo: 60 * 27, fromSender: true,context: context)
            _ = FriendsController.createMessageWithText(text: "How are you", from: friend, minutesAgo: 60 * 26,fromSender: true, context: context)
            _ = FriendsController.createMessageWithText(text: "All is well", from: friend, minutesAgo: 60 * 25, fromSender: false,context: context)
            
            let friend2 = FriendCD(context: context)
            friend2.setValuesForKeys([#keyPath(FriendCD.name) : "Ro Eel",
                                     #keyPath(FriendCD.profilePicture) : "icons8-jack-o-lantern-96"])
            
            _ = FriendsController.createMessageWithText(text: "Hello", from: friend2, minutesAgo: 5, fromSender: false,context: context)
            _ = FriendsController.createMessageWithText(text: "I am hungry", from: friend2, minutesAgo: 4, fromSender: true,context: context)
            _ = FriendsController.createMessageWithText(text: "Give me fooood", from: friend2, minutesAgo: 3, fromSender: false,context: context)
            _ = FriendsController.createMessageWithText(text: "I am now hangry. I am very hot. I am very cold. I am bored. I want to play games ... I am now hangry. I am very hot. I am very cold. I am bored. I want to play games ...", from: friend2, minutesAgo: 2, fromSender: true,context: context)
            
            let friend3 = FriendCD(context: context)
            friend3.setValuesForKeys([#keyPath(FriendCD.name) : "Ray El",
                                     #keyPath(FriendCD.profilePicture) : "icons8-sunflower-96"])
            
            _ = FriendsController.createMessageWithText(text: "Hello", from: friend3, minutesAgo: 5, fromSender: false,context: context)
            _ = FriendsController.createMessageWithText(text: "Can I watch TV", from: friend3, minutesAgo: 4, fromSender: true,context: context)
            _ = FriendsController.createMessageWithText(text: "Give me fooood", from: friend3, minutesAgo: 3, fromSender: false,context: context)
            _ = FriendsController.createMessageWithText(text: "What do we have? What options do I have? I dont want this, I dont want that. I am the best", from: friend3, minutesAgo: 2, fromSender: true, context: context)

            delegate?.saveContext()
            
        }
        loadDataFromCD()
    }
    
    func loadDataFromCD() -> Void{
        
        messages = [MessageCD]()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext{
            var friends: [FriendCD]?
            // Loop through friends and retrieve the latest message for each friend
            let friendRequest: NSFetchRequest<FriendCD> = NSFetchRequest(entityName: "FriendCD")
            do{
                // perform query and get result
                let result = try context.fetch(friendRequest)
                if !result.isEmpty{
                    friends = result
                }
            } catch {
                print("Error Loading data from CD: \(error)")
            }
            
            guard let friends else {return}
            for friend in friends{
                // similar to select * from Table
                let fetchMessageCD: NSFetchRequest<MessageCD> = MessageCD.fetchRequest()
                // Add a sort condition
                let sortByDate = NSSortDescriptor(key: #keyPath(MessageCD.date), ascending: false)
                fetchMessageCD.sortDescriptors = [sortByDate]
                // Adding where clause
                fetchMessageCD.predicate = NSPredicate(format: "friend = %@", friend)
                // set a limit oon number of rows to return
                fetchMessageCD.fetchLimit = 1
                do{
                    // perform query and get result
                    let result = try context.fetch(fetchMessageCD)
                    if !result.isEmpty {
                        messages.append(result.first!)
                    }
                } catch {
                    print("Error Loading data from CD: \(error)")
                }

            }
            messages.sort { (messageOne, messageTwo) in
                // Return True if first element should be ordered before second,
                // Return False if second element should be ordered first
                messageOne.date! >= messageTwo.date!
            }
        }
    }
    
    func clearDataFromCD() -> Void{
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext{
            // similar to select * from Table
            
            do{
                
                let entities = ["FriendCD", "MessageCD"]
                
                for entity in entities {
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
                    let result = try context.fetch(fetchRequest)
                    for item in result{
                        context.delete(item)
                    }
                }
                delegate?.saveContext()
                
            } catch {
                print("Error Loading data from CD: \(error)")
            }
            
        }
    }
    
    static func createMessageWithText(text: String, from: FriendCD, minutesAgo: Double, fromSender: Bool, context: NSManagedObjectContext) -> MessageCD{
        let message = MessageCD(context: context)
        message.setValuesForKeys([#keyPath(MessageCD.text) : text,
                                  #keyPath(MessageCD.date) : Date().addingTimeInterval(TimeInterval(-minutesAgo * 60)),
                                  #keyPath(MessageCD.fromSender): fromSender,
                                  #keyPath(MessageCD.friend) : from])
        return message
    }
    
    func setupDummyData() -> Void {
        /*
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
        */
        
    }
    
    
    
}

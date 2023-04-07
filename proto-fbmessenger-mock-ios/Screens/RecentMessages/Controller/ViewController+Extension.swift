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
            
            let message = MessageCD(context: context)
            message.setValuesForKeys([#keyPath(MessageCD.text) : "Hello",
                                      #keyPath(MessageCD.date) : Date(),
                                      #keyPath(MessageCD.friend) : friend])
            
            let friend2 = FriendCD(context: context)
            friend2.setValuesForKeys([#keyPath(FriendCD.name) : "Ro Eel",
                                     #keyPath(FriendCD.profilePicture) : "icons8-jack-o-lantern-96"])
            
            let message2 = MessageCD(context: context)
            message2.setValuesForKeys([#keyPath(MessageCD.text) : "Its halloween. Time to get some candy. this is meant to be a long message. Your friends message goes here. Bla Bla blah blah Bla this is too long... ",
                                      #keyPath(MessageCD.date) : Date(),
                                      #keyPath(MessageCD.friend) : friend2])
            delegate?.saveContext()
            
        }
        loadDataFromCD()
    }
    
    func loadDataFromCD() -> Void{
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext{
            // similar to select * from Table
            let fetchMessageCD: NSFetchRequest<MessageCD> = MessageCD.fetchRequest()
            // Add a sort conditin
            let sortByName = NSSortDescriptor(key: #keyPath(MessageCD.text), ascending: true)
            fetchMessageCD.sortDescriptors = [sortByName]
            do{
                // perform query and get result
                let result = try context.fetch(fetchMessageCD)
                messages = result
            } catch {
                print("Error Loading data from CD: \(error)")
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

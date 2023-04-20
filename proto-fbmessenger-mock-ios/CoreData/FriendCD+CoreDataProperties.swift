//
//  FriendCD+CoreDataProperties.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/20/23.
//
//

import Foundation
import CoreData


extension FriendCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendCD> {
        return NSFetchRequest<FriendCD>(entityName: "FriendCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var profilePicture: String?
    @NSManaged public var messages: NSSet?
    @NSManaged public var lastMessage: MessageCD?

}

// MARK: Generated accessors for messages
extension FriendCD {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageCD)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageCD)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension FriendCD : Identifiable {

}

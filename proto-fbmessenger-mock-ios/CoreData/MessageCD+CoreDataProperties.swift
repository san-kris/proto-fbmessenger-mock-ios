//
//  MessageCD+CoreDataProperties.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/11/23.
//
//

import Foundation
import CoreData


extension MessageCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageCD> {
        return NSFetchRequest<MessageCD>(entityName: "MessageCD")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var fromSender: Bool
    @NSManaged public var friend: FriendCD?

}

extension MessageCD : Identifiable {

}

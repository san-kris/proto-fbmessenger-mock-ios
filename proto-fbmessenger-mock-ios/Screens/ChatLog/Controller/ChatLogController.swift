//
//  ChatLogController.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/8/23.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController {
    
    private let messageCell = "messageCell"
    
    private var messages: [MessageCD]? {
        didSet{
            guard let messages else {return}
            print("Retrieved Messages: \(messages.count)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }

    var friend: FriendCD? {
        didSet{
            print("Getting chat log for \(friend!.name!)")
            navigationItem.title = friend?.name
            messages = getChatLog()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(MessageCell.self, forCellWithReuseIdentifier: messageCell)

        // Do any additional setup after loading the view.
        collectionView.alwaysBounceVertical = true
    }
    
    deinit {
        print("ChatLogController Deinit Called")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}


//MARK: - UICollectionViewDataSource
extension ChatLogController{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let count = messages?.count{
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCell, for: indexPath) as! MessageCell
        // Configure the cell
        cell.message = messages![indexPath.item]
        cell.backgroundColor = .yellow
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ChatLogController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Need to safely unwrap message
        var height: CGFloat = 5
        if let messageText = messages![indexPath.item].text{
            height = calculateDisplayHeightForText(messageText, withWidth: 250)
            height = height + 10
            print("Message cell height is \(height) for text: \(messageText)")
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func calculateDisplayHeightForText(_ text: String, withWidth: CGFloat) -> CGFloat{
        let displaySize = CGSize(width: withWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let newSize = NSString(string: text).boundingRect(with: displaySize,
                                                          options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                          attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
                                                          context: nil)
        print(newSize)
        return  ceil(newSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}


//MARK: - Extensioon for Loading Chat Log from Core Dat
extension ChatLogController{
    func getChatLog() -> [MessageCD]? {
        
        // Reading messages from Core Data
        // 1. Get App Delegate
        let delegate = UIApplication.shared.delegate as? AppDelegate
        // 2. Get Context
        if let context = delegate?.persistentContainer.viewContext{
            // 3. Create fetch Request
            let fetchFriendMessages: NSFetchRequest<MessageCD> = NSFetchRequest(entityName: "MessageCD")
            // 4. Set Predicate, Limit and Sort conditions
            // 4.1 Sort By Date
            let sortByDate = NSSortDescriptor(key: #keyPath(MessageCD.date), ascending: true)
            fetchFriendMessages.sortDescriptors = [sortByDate]
            // 4.2 Get lsat 20 messages
            fetchFriendMessages.fetchLimit = 20
            // 4.3 Only for user
            fetchFriendMessages.predicate = NSPredicate(format: "friend.name = %@", friend!.name!)
            // 5. Execute fetch request
            do{
                let result = try context.fetch(fetchFriendMessages)
                if !result.isEmpty{
                    return result
                }
            } catch {
                print("Error while retrieving messages: \(error)")
            }
            
            // 6. Display results in cell
        }
        return nil
    }
}

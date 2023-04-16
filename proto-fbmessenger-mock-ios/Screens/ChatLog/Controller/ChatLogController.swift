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
                self.scrollToBottom()
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
    
    let sendMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type message here"
        tf.backgroundColor = .gray
        return tf
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(handleMessageSend), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func handleMessageSend(sender: UIButton) -> Void{
        guard let messageText = messageTextField.text else {return}
        print("Sending message: \(messageText)")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        if let friend = messages?.first?.friend{
            let newMessage = FriendsController.createMessageWithText(text:messageText,
                                                              from: friend,
                                                              minutesAgo: 0,
                                                              fromSender: true,
                                                              context: context)
            messages?.append(newMessage)
            delegate.saveContext()
            
            messageTextField.text = ""
            
        }
        
        
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // create a fetch request assciated with Fetched Request Controller
        let fr: NSFetchRequest<MessageCD> = MessageCD.fetchRequest()
        // Need a sort descriptor. Not using onoe causes crash
        fr.sortDescriptors = [NSSortDescriptor(key: #keyPath(MessageCD.date), ascending: true)]
        // we need to filter query to only desired friend
        fr.predicate = NSPredicate(format: "friend.name == %@", friend?.name ?? "")
        // get Managed Object
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try fetchedResultsController.performFetch()
            print("Sections fetched: \(fetchedResultsController.sections!.count) and items fetched in section 1: \(fetchedResultsController.sections!.first!.numberOfObjects)")
            
        } catch {
            print("Failed to fetch result: \(error)")
        }
        

        // Register cell classes
        self.collectionView!.register(MessageCell.self, forCellWithReuseIdentifier: messageCell)

        // Do any additional setup after loading the view.
        collectionView.alwaysBounceVertical = true
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupNavigationBarAction()
    }
    
    func setupView() -> Void{
        view.addSubview(sendMessageView)
        sendMessageView.addSubview(sendButton)
        sendMessageView.addSubview(messageTextField)
        
        setupLayout()
    }
    
    var textFieldBottomConstraint: NSLayoutConstraint?
    
    func setupLayout() -> Void{
        sendMessageView.translatesAutoresizingMaskIntoConstraints = false
        sendMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        sendMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        textFieldBottomConstraint = sendMessageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        textFieldBottomConstraint!.isActive = true
        sendMessageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.topAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: 0).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: sendMessageView.bottomAnchor, constant: 0).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: sendMessageView.trailingAnchor, constant: 0).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.leadingAnchor.constraint(equalTo: sendMessageView.leadingAnchor, constant: 0).isActive = true
        messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 0).isActive = true
        messageTextField.topAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: 0).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: sendMessageView.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func setupNavigationBarAction() -> Void {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleSilulate))
    }
    
    @objc func handleSilulate(sender: UIBarButtonItem) -> Void{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        if let friend = messages?.first?.friend{
            let newMessage = FriendsController.createMessageWithText(text:"Hello Darkness, my old friend", from: friend, minutesAgo: 1, fromSender: false, context: context)
            messages?.append(newMessage)
            delegate.saveContext()
            
            messages = messages?.sorted(by: { (messageOne, messageTwo) in
                if let messageOneDate = messageOne.date, let messagetTwoDate = messageTwo.date{
                    return messageOneDate <= messagetTwoDate ? true : false
                }
                return true
            })
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        print("ChatLogController Deinit Called")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        
        if let userInfo = notification.userInfo{
            guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                print("Failed to get Keyboard Frame")
                return
            }
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            textFieldBottomConstraint?.constant = isKeyboardShowing ? -keyboardSize.height : 0
            
            UIView.animate(withDuration: 0,
                           delay: 0,
                           options: UIView.AnimationOptions.curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { (completed) in
                print("Animation Completed: \(completed)")
                self.scrollToBottom()
            }

        }
    }
    
    func scrollToBottom() -> Void{
        let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath , at: UICollectionView.ScrollPosition.bottom, animated: true)
        // collectionView.contentOffset.y = 50
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension ChatLogController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == NSFetchedResultsChangeType.insert{
            // collectionView.insertItems(at: <#T##[IndexPath]#>)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ChatLogController{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        // Return number of items in section zero
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCell, for: indexPath) as! MessageCell
        // Configure the cell
        // let message = fetchedResultsController.object(at: indexPath)
        cell.message = messages![indexPath.item]
        cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ChatLogController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Need to safely unwrap message
        var height: CGFloat = 5
        if let messageText = messages![indexPath.item].text{
            height = calculateDisplayHeightForText(messageText, withWidth: 250)
            // set minunum height to 35 to ensure profile image can fit
            height = height < 20 ? 37 : height + 15
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
    
    
    
}


//MARK: - UICollectionViewDelegate
extension ChatLogController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Dismiss the keyboard
        view.endEditing(true)
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

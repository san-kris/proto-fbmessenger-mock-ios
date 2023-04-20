//
//  ViewController.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/5/23.
//

import UIKit
import CoreData

class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellID = "cellID"
    
    // var messages = [Message]()
    
    var messages = [MessageCD]()
    
    var codeBlocks = [BlockOperation]()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FriendCD> = FriendCD.fetchRequest()
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: #keyPath(FriendCD.lastMessage.date), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up dummy data array
        // setupDummyData()
        
        // setting dummy data in Core Data
        setupDummyCoreData()
        do{
            try fetchedResultsController.performFetch()
        } catch {
            print("Error while fetching friends list: \(error)")
        }
        
        setupView()
     
    }
    
    func setupView() -> Void {
        
        navigationItem.title = "Friends"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 0.95)
        collectionView.alwaysBounceVertical = true
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: cellID)

    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects{
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FriendCell
        if let friend = fetchedResultsController.sections?[indexPath.section].objects?[indexPath.item] as? FriendCD{
            cell.message = friend.lastMessage
        }
        //cell.message = messages[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell selected \(indexPath.item)")
        if let friend = fetchedResultsController.sections?[indexPath.section].objects?[indexPath.item] as? FriendCD{
            let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.friend = friend
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("screen dimention: \(size)")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.invalidateLayout()
    }


}

extension FriendsController: NSFetchedResultsControllerDelegate{
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("Object changed at indexPath: \(indexPath) and newIndexPath: \(newIndexPath)")
        codeBlocks.append(BlockOperation(block: {
            self.collectionView.reloadItems(at: [indexPath!, newIndexPath!])
        }))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Friends Content Did Change")
        for block in codeBlocks{
            block.start()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Friends will change")
    }
}


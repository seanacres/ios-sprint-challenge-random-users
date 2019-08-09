//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by Sean Acres on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    let networkingController = NetworkingController()
    let cache: Cache<String, Data> = Cache()
    private let photoFetchQueue: OperationQueue = OperationQueue()
    private var fetchOps: [String : PhotoFetchOperation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()

        networkingController.getUsers { (error) in
            if let error = error {
                NSLog("Error getting users: \(error)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkingController.randomUsers.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }

        let user = networkingController.randomUsers[indexPath.row]
        cell.contactName.text = user.name.capitalized
        
        loadImage(forCell: cell, forIndexPath: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let id = networkingController.randomUsers[indexPath.row].phone
        fetchOps[id]?.cancel()
    }
    
    // MARK: - Functions
    private func loadImage(forCell cell: ContactTableViewCell, forIndexPath indexPath: IndexPath) {
        let contact = networkingController.randomUsers[indexPath.row]
        
        // Set image immediately if it already exists
        if let data = cache.value(for: contact.phone) {
            cell.contactImageView.image = UIImage(data: data)
            return
        }
        
        // If not fetch the image and then cache it for later use
        let photoFetchOperation = PhotoFetchOperation(imageURL: contact.imageURL)
        let cacheOperation = BlockOperation {
            guard let data = photoFetchOperation.imageData else { return }
            self.cache.cache(value: data, for: contact.phone)
        }
        let imageSetOperation = BlockOperation {
            guard let data = photoFetchOperation.imageData else { return }
            DispatchQueue.main.async {
                // If the row is offscreen, don't set the image
                if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                    cell.contactImageView.image = UIImage(data: data)
                }
            }
        }
        
        // Both cache and image set need a photo to be fetched first
        cacheOperation.addDependency(photoFetchOperation)
        imageSetOperation.addDependency(photoFetchOperation)
        
        photoFetchQueue.addOperations([photoFetchOperation, cacheOperation, imageSetOperation], waitUntilFinished: false)
        
        // Add photo fetch to dictionary so it can be cancelled if row is offscreen
        fetchOps[contact.phone] = photoFetchOperation
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contactDetailVC = segue.destination as? ContactDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
        contactDetailVC.randomUser = networkingController.randomUsers[indexPath.row]
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell else { return }
        contactDetailVC.userImage = cell.contactImageView.image
    }

}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkingController.getUsers { (error) in
            if let error = error {
                NSLog("Error getting users: \(error)")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return networkingController.randomUsers.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }

        let user = networkingController.randomUsers[indexPath.row]
        cell.contactName.text = user.name

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contactDetailVC = segue.destination as? ContactDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
        contactDetailVC.randomUser = networkingController.randomUsers[indexPath.row]
    }

}

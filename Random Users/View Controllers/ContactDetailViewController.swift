//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Sean Acres on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var randomUser: RandomUser?
    var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        if let user = randomUser {
            phoneNumberLabel.text = user.phone
            emailLabel.text = user.email
            title = user.name.capitalized
        }
        
        if let image = userImage {
            imageView.image = image
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

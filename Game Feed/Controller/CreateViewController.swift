//
//  CreateViewController.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 15/10/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    @IBOutlet var photo: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if let name = nameTextField.text, let company = companyTextField.text, let email = emailTextField.text {
            if name.isEmpty {
                textEmpty("Name")
            } else if company.isEmpty {
                textEmpty("Company")
            } else if email.isEmpty {
                textEmpty("Email")
            } else {
                saveProfile(name, company, email)
                self.performSegue(withIdentifier: "moveToProfile", sender: self)
            }
        }
    }
    
    func saveProfile(_ name: String, _ company: String, _ email: String) {
        ProfileModel.stateLogin = true
        ProfileModel.name = name
        ProfileModel.company = company
        ProfileModel.email = email
    }
    
    func textEmpty(_ field: String) {
        let alert = UIAlertController(title: "Alert", message: "\(field) is empty", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  UpdateViewController.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 16/10/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    @IBOutlet var photo: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProfileModel.stateLogin = true
        nameTextField.text = ProfileModel.name
        companyTextField.text = ProfileModel.company
        emailTextField.text = ProfileModel.email
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        if let name = nameTextField.text, let company = companyTextField.text, let email = emailTextField.text {
            if name.isEmpty {
                textEmpty("Name")
            } else if company.isEmpty {
                textEmpty("Email")
            } else if email.isEmpty {
                textEmpty("Profession")
            } else {
                saveProfil(name, company, email)
                
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func saveProfil(_ name: String, _ company: String, _ email: String) {
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

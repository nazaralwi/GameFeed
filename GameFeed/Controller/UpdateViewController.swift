import UIKit

class UpdateViewController: UIViewController {
    @IBOutlet var photo: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func saveProfil(_ name: String, _ company: String, _ email: String) {
        ProfileModel.stateEdit = true
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

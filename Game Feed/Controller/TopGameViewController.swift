import UIKit

class TopGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
}

//
//  MainViewController.swift
//  RidProyect
//
//  Created by Pablo La Plata on 28/01/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var ingresarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
    }

    
        @IBAction func ingresarBtnTapped(_ sender: Any){
        
        let email = emailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
            /*
                let IncioViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.IncioViewController) as? InicioViewController
                    
                self.view.window?.rootViewController = IncioViewController
                self.view.window?.makeKeyAndVisible()
            */
            }
        }
    }
}

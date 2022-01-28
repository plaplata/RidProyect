//
//  RegistroViewController.swift
//  RidProyect
//
//  Created by user191222 on 1/27/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class RegistroViewController: UIViewController {
    

    @IBOutlet weak var NombreTextField: UITextField!
    
    @IBOutlet weak var ApellidosTextField: UITextField!
    
    @IBOutlet weak var CorreoTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var RegistrarseBtn: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        // Hide the error label
        ErrorLabel.alpha = 0
            
    }
    
    // Validar que lo introducido en los campos sea correcto. Si es correcto este metodo devuelve 'nil', De otro modo devuelve un mensaje de error.
    func validarCampos() -> String? {
        
        //Validar que todos los campos están llenos
        if  NombreTextField.text?.trimmingCharacters(in:      .whitespacesAndNewlines) == "" ||
            ApellidosTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            CorreoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Por favor llena todos los campos"
        }
        let LimpiarPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.esPasswordValido(LimpiarPassword) == false{
            return "Por favor asegurate de que tu contraseña tenga al menos 8 caracteres, o que no tenga ningun caracter especial"
        }
        
        return nil
    }

    @IBAction func RegistrarseTapped(_ sender: Any) {
        
    let error = validarCampos()
        if error != nil {
            showError(error!)
        }
        else {
            	
            let nombre = NombreTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let apellido = ApellidosTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let email = CorreoTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    self.showError("Error creando usuario")
                }
                else{
                    
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: [
                            "Nombre":nombre,
                            "Apellido":apellido,
                            "uid":result!.user.uid
                    ]) {(error) in
                        
                        if error != nil {
                            self.showError("Error guardando el usuario")
                        }
                    }
                    self.transicionInicio()
                }
            }
        }
    }
    func showError(_ message:String) {
        
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
        func transicionInicio() {
                
            let IncioViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.IncioViewController) as? InicioViewController
                
                view.window?.rootViewController = IncioViewController
                view.window?.makeKeyAndVisible()
            }
}

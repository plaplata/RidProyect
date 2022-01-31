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
    

    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var apellidosTextField: UITextField!
    
    @IBOutlet weak var correoTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var RegistrarseBtn: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func clickBtnBack(_ sender:Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        // Hide the error label
        errorLabel.alpha = 0
            
    }
    
    // Validar que lo introducido en los campos sea correcto. Si es correcto este metodo devuelve 'nil', De otro modo devuelve un mensaje de error.
    func validarCampos() -> String? {
        
        //Validar que todos los campos están llenos
        if  nombreTextField.text?.trimmingCharacters(in:      .whitespacesAndNewlines) == "" ||
            apellidosTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            correoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Por favor llena todos los campos"
        }
        let limpiarPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.esPasswordValido(limpiarPassword) == false{
            return "Por favor asegúrate de que tu contraseña tenga al menos 8 caracteres y que incluya al menos una letra en mayúscula y un número"
        }
        
        return nil
    }
    
    
    @IBAction func registrarseTapped(_ sender: Any) {
        //Validar campos
        if let error = validarCampos() {
            showError(error)
            return
        }
        
        //Creando el usuario
        let nombre = nombreTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let apellido = apellidosTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let email = correoTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        
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
                        self.showError("Error guardando los datos del usuario")
                    }
                }
                self.transicionInicio()
            }
        }
    }
    
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transicionInicio() {
                
        self.performSegue(withIdentifier:"InicioViewController", sender: nil)
    }
}

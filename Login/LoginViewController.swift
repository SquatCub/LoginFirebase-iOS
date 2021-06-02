//
//  LoginViewController.swift
//  Login
//
//  Created by Brandon Rodriguez Molina on 02/06/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraseñaTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func loginButton(_ sender: UIButton) {
        if let email = correoTextField.text, let password = contraseñaTextField.text  {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    var msj = ""
                    switch e.localizedDescription {
                        case "The password is invalid or the user does not have a password.":
                            msj = "Constraseña incorrecta"
                        break
                        case "There is no user record corresponding to this identifier. The user may have been deleted.":
                            msj = "Usuario no valido"
                        break
                        case "The email address is badly formatted.":
                            msj = "Correo con formato incorrecto"
                        break
                        default:
                            msj = "Error desconocido"
                            break
                    }
                    self.mensajeAlerta(mensaje: msj)
                } else {
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    func mensajeAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
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

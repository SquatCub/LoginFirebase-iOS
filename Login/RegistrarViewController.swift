//
//  RegistrarViewController.swift
//  Login
//
//  Created by Brandon Rodriguez Molina on 02/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistrarViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraseñaTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registrarButton(_ sender: UIButton) {
        if let email = correoTextField.text, let nombre = nombreTextField.text,  let password = contraseñaTextField.text  {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("Error al crear usuario \(e.localizedDescription)")
                    var msj = ""
                    switch e.localizedDescription {
                        case "The email address is already in use by another account.":
                            msj = "Correo ya en uso por otro usuario"
                        break
                        case "The email address is badly formatted.":
                            msj = "Correo con formato incorrecto"
                        break
                        case "The password must be 6 characters long or more.":
                            msj = "La contraseña debe tener mas de 6 caracteres "
                        break
                        default:
                            msj = "Error desconocido"
                            break
                    }
                    self.mensajeAlerta(mensaje: msj)
                } else {
                    let documentoNombre = email
                    self.db.collection("perfiles").document(documentoNombre).setData(["usuario": email, "nombre": nombre, "imagen": "noimage"]) { (error) in
                        //En caso de error
                        if let e = error {
                            print("Error al guardar en Firestore \(e.localizedDescription)")
                        } else {
                            //En caso de enviar
                            print("Se guardo la info en firestore")
                        }
                    }
                    self.performSegue(withIdentifier: "registro", sender: self)
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

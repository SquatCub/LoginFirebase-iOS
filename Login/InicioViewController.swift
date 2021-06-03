//
//  InicioViewController.swift
//  Login
//
//  Created by Brandon Rodriguez Molina on 03/06/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class InicioViewController: UIViewController {

    var mensajes = [Mensaje]()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var mensaje: UITextField!
    @IBOutlet weak var tabla: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        cargarMensajes()
    }
    func cargarMensajes() {
        db.collection("mensajes").order(by: "fecha").addSnapshotListener() { (querySnapshot, err) in
            //Vaciar arreglo de chats
            self.mensajes = []
            if let e = err {
                print("Error al obtener datos \(e.localizedDescription)")
            } else {
                if let snapshotDocumentos = querySnapshot?.documents {
                    for document in snapshotDocumentos {
                        print("\(document.data())")
                        //Crear objeto Mensaje
                        let datos = document.data()
                        //Obtener parametros
                        guard let remitenteFS = datos["remitente"] as? String else { return }
                        guard let mensajeFS = datos["mensaje"] as? String else { return }
                        //Crear objeto y agregarlo al arreglo
                        let nuevoMensaje = Mensaje(remitente: remitenteFS, cuerpo: mensajeFS)
                        self.mensajes.append(nuevoMensaje)
                        
                        DispatchQueue.main.async {
                            self.tabla.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func enviarButton(_ sender: UIButton) {
        if let mensajeEnviar = mensaje.text, let remitente = Auth.auth().currentUser?.email {
            db.collection("mensajes").addDocument(data: ["remitente": remitente, "mensaje": mensajeEnviar, "fecha": Date().timeIntervalSince1970]) { (error) in
                //En caso de error
                if let e = error {
                    print("Error al guardar en Firestore \(e.localizedDescription)")
                } else {
                    //En caso de enviar
                    print("Se guardo la info en firestore")
                    self.mensaje.text = ""
                    self.cargarMensajes()
                }
            }
        }
        
        
    }
    @IBAction func salirButton(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Sesion cerrada")
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error al salir ", signOutError)
        }
    }
}

extension InicioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = mensajes[indexPath.row].cuerpo
        celda.detailTextLabel?.text = mensajes[indexPath.row].remitente
        return celda
    }
    
    
}

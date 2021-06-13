import UIKit
import Firebase
import FirebaseFirestore

class InicioViewController: UIViewController {
    var nombreUsuario: String?
    var mensajes = [Mensaje]()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var mensaje: UITextField!
    @IBOutlet weak var tabla: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MensajeTableViewCell", bundle: nil)
        tabla.register(nib, forCellReuseIdentifier: "celdaMensaje")
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "perfil" {
            let destino = segue.destination as! PerfilViewController
            destino.nombreUsuario = nombreUsuario!
        }
    }
    
}

extension InicioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "celdaMensaje", for: indexPath) as! MensajeTableViewCell
        celda.mensaje.text = mensajes[indexPath.row].cuerpo
        celda.contacto.text = mensajes[indexPath.row].remitente
        
        let perfil = self.db.collection("perfiles").document(mensajes[indexPath.row].remitente)
        perfil.getDocument{ (document, error) in
            if let document = document, document.exists {
                celda.contacto.text = "De: \(document.data()!["nombre"]!)"
                let urlString = document.data()!["imagen"] as? String
                let url = URL(string: urlString!)

                DispatchQueue.main.async { [weak self] in
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                celda.imagenContacto.image = image
                            }
                        }
                    }
                }
                } else {
                    print("Document does not exist")
                }
        }
        
        return celda
    }
    
    
}

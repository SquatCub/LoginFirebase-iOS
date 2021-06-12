//
//  PerfilViewController.swift
//  Login
//
//  Created by Brandon Rodriguez Molina on 12/06/21.
//

import UIKit
import Firebase
import FirebaseStorage

class PerfilViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imagenPerfil: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestura = UITapGestureRecognizer( target: self, action: #selector(clickImagen))
        
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        
        imagenPerfil.addGestureRecognizer(gestura)
        imagenPerfil.isUserInteractionEnabled = true
    }
    
    @objc func clickImagen(gestura: UITapGestureRecognizer) {
        print("Cambiar imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
        
    }
    @IBAction func guardarDatos(_ sender: UIButton) {
        guard let image = imagenPerfil.image, let datosImage = image.jpegData(compressionQuality: 1.0) else {
            print ("Error")
            return
        }
        
        //Asignar ID unico a los datos de la foto
        let imageNombre = UUID().uuidString
        let imageReferencia = Storage.storage().reference().child("imagenes").child(imageNombre)
        
        //Subir datos a Firestorage
        imageReferencia.putData(datosImage, metadata: nil) { (metadata, error) in
            if let err = error {
                print("Error al subir la imagen \(err.localizedDescription)")
            }
            imageReferencia.downloadURL { (url, error) in
                if let err = error {
                    print("Error al subir la imagen \(err.localizedDescription)")
                    return
                }
                guard let url = url else {
                    print("Error al crear url de la imagen")
                    return
                }
                
                let dataReferencia = Firestore.firestore().collection("imagenes").document()
                let documentoID = dataReferencia.documentID
                
                let urlString = url.absoluteString
                
                let datosEnviar = ["id": documentoID, "url": urlString]
                
                dataReferencia.setData(datosEnviar) { (error) in
                    if let err = error {
                        print("Error al mandar datos de imagen \(err.localizedDescription)")
                        return
                    } else {
                        print("Se guardo correctamente en FS")
                    }
                }
            }
        }
        
    }
    
}

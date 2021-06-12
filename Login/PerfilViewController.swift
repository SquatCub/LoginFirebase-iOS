//
//  PerfilViewController.swift
//  Login
//
//  Created by Brandon Rodriguez Molina on 12/06/21.
//

import UIKit
import Firebase

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
        }
        
        //Asignar ID unico a los datos de la foto
        let imageNombre = UUID().uuidString
        let imageReferencia = Storage.storage()
        
    }
    
}

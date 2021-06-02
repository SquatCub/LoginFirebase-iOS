//
//  ViewController.swift
//  Login
//
//  Created by Brandon Rodriguez Molina on 31/05/21.
//

import UIKit
import CLTypingLabel

class ViewController: UIViewController {

    @IBOutlet weak var mensajeBienvenida: CLTypingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mensajeBienvenida.text = "Hola a todos, esta es una prueba del cltyping label, un pod para xcode"
    }


}


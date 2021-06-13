//
//  MensajeTableViewCell.swift
//  Login
//
//  Created by Brandon Rodriguez Molina on 12/06/21.
//

import UIKit

class MensajeTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenContacto: UIImageView!
    @IBOutlet weak var mensaje: UILabel!
    @IBOutlet weak var contacto: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imagenContacto.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

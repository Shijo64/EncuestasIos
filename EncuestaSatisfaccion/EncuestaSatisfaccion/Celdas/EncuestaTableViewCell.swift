//
//  EncuestaTableViewCell.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 24/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit

class EncuestaTableViewCell: UITableViewCell {

    @IBOutlet weak var tipoEncuestaLabel: UILabel!
    @IBOutlet weak var encuestaCellView: UIView!
    @IBOutlet weak var pendienteCantidadLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(encuesta:EncuestaModel, pendientes:Int){
        self.encuestaCellView.layer.cornerRadius = 15
        self.tipoEncuestaLabel.text = encuesta.Name! + "    (\(pendientes))"
    }
}

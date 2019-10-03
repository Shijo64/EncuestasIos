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
    @IBOutlet weak var completadasLabel: UILabel!
    @IBOutlet weak var pendientesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(encuesta:EncuestaModel){
        self.encuestaCellView.layer.cornerRadius = 15
        self.tipoEncuestaLabel.text = encuesta.Name!
        self.checkPendientes(currentEncuesta: encuesta)
    }
    
    func checkPendientes(currentEncuesta: EncuestaModel){
        let completadasTotales = RealmHelper.sharedInstance.getObjects(type: EncuestaEnviadaModel.self) as! [EncuestaEnviadaModel]
        let pendientesTotales = RealmHelper.sharedInstance.getObjects(type: EncuestaBO.self) as! [EncuestaBO]
        let completadas = completadasTotales.filter{$0.idEncuesta == currentEncuesta.Id}
        let pendientes = pendientesTotales.filter{$0.EncuestaId == currentEncuesta.Id}
        if(pendientes.count > 0){
            self.pendientesLabel.text = "\(pendientes.count) pendientes"
        }
        
        if(completadas.count > 0){
            self.completadasLabel.text = "\(completadas.count) completadas"
        }
    }
}

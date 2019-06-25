//
//  OrderDateViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Jaime Leija Morales on 13/06/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit

class OrderDateViewController: UIViewController {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate:FechaDelegate?
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateView.layer.cornerRadius = 10
        self.dateView.layer.masksToBounds = true
        
        self.datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        self.datePicker.date = self.currentDate
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker){
        let fecha = sender.date
        delegate?.seleccionarFecha(fecha: fecha)
        self.dismiss(animated: true, completion: nil)
    }
}

protocol FechaDelegate: class{
    func seleccionarFecha(fecha: Date)
}

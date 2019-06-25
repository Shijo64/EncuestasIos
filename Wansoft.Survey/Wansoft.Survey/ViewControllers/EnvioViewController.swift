//
//  EnvioViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Jaime Leija Morales on 31/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit

class EnvioViewController: UIViewController {

    @IBOutlet weak var aceptarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aceptarButton.layer.cornerRadius = 15
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func confirmarEnvio(_ sender: Any) {
        SharedData.sharedInstance.respuestas = []
        self.navigationController?.popToRootViewController(animated: true)
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

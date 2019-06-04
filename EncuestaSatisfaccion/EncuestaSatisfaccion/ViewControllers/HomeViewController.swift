//
//  HomeViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 25/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController, UITextFieldDelegate, BarcodeDelegate, ResumenDelegate {

    @IBOutlet weak var tipoEncuestaLabel: UILabel!
    @IBOutlet weak var iniciarButton: UIButton!
    @IBOutlet weak var numeroOrdenTextfield: UITextField!
    @IBOutlet weak var codigoBarrasButton: UIButton!
    
    var encuesta:EncuestaModel?
    var encuestaSeleccionada:Bool = false
    var timer = Timer()
    var isTimerRunning = false
    var encuestasPendientes:[EncuestaBO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo-completo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.iniciarButton.layer.cornerRadius = 15
        self.codigoBarrasButton.layer.cornerRadius = 15
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.numeroOrdenTextfield.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.numeroOrdenTextfield.text = ""
        if(SharedData.sharedInstance.ordenManual){
            self.numeroOrdenTextfield.isUserInteractionEnabled = true
        }else{
            self.numeroOrdenTextfield.isUserInteractionEnabled = false
        }
        self.buscarPendientes()
        self.getEncuestaDefault()
        SharedData.sharedInstance.dismissProgressIfVisible()
        self.numeroOrdenTextfield.resignFirstResponder()
    }
    
    func getEncuestaDefault(){
        let encuestaSelectGuardada = RealmHelper.sharedInstance.getObject(type: EncuestaSeleccionadaModel.self) as? EncuestaSeleccionadaModel
        if((encuestaSelectGuardada?.id)! > 0) {
            let predicado = "Id = \(encuestaSelectGuardada!.idEncuesta)"
            self.encuesta = (RealmHelper.sharedInstance.getObjectsWithPredicate(type: EncuestaModel.self, predicate: predicado)?.first as! EncuestaModel)
        }
        if(self.encuesta?.Name == nil) {
            let predicate = "Default = true"
            let encuestas = RealmHelper.sharedInstance.getObjectsWithPredicate(type: EncuestaModel.self, predicate: predicate) as! [EncuestaModel]
            self.encuesta = encuestas.first
            self.tipoEncuestaLabel.text = self.encuesta?.Name
        }else{
            self.tipoEncuestaLabel.text = self.encuesta?.Name
        }

    }
    
    @objc func buscarPendientes(){
        let network = NetworkHelper.sharedInstance
        switch network.reachability.connection {
        case .none:
            if(!self.isTimerRunning){
                timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(buscarPendientes), userInfo: nil, repeats: false)
                self.isTimerRunning = true
            }
        default:
            self.isTimerRunning = false
            let data = RealmHelper.sharedInstance.getObjects(type: EncuestaBO.self)
            self.encuestasPendientes = (data as! [EncuestaBO])
            if(((self.encuestasPendientes?.count)!) > 0){
                let manager = EncuestaManager()
                for encuesta in self.encuestasPendientes!{
                    let predicate = "idEncuestaBO = \(encuesta.Id)"
                    let respuestas = RealmHelper.sharedInstance.getObjectsWithPredicate(type: EncuestaRespuestas.self, predicate: predicate) as! [EncuestaRespuestas]
                    manager.sendEncuesta(encuesta: encuesta, respuestas: respuestas){ result in
                        RealmHelper.sharedInstance.deleteObjects(objects: respuestas)
                    }
                }
                RealmHelper.sharedInstance.deleteObjects(objects: self.encuestasPendientes!)
            }
        }
    }
    
    @IBAction func iniciarEncuesta(_ sender: Any) {
        if(self.numeroOrdenTextfield.text == ""){
            self.errorHighlightTextField(textField: self.numeroOrdenTextfield)
        }else{
            SharedData.sharedInstance.numeroOrden = Int(self.numeroOrdenTextfield.text!)!
            SharedData.sharedInstance.showProgress()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "EncuestaController") as! EncuestaViewController
            controller.encuesta = self.encuesta
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func scanBarCode(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "barcodeController") as! BarCodeViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Barcode Delegate
    func sendCodigo(codigo: String) {
        self.numeroOrdenTextfield.text = codigo
        self.removeErrorHighlightTextField(textField: self.numeroOrdenTextfield)
    }
    
    //MARK: TEXTFIELD
    /*func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.numeroOrdenText
    }*/
    
    // Text Field is empty - show red border
    func errorHighlightTextField(textField: UITextField){
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }
    
    // Text Field is NOT empty - show gray border with 0 border width
    func removeErrorHighlightTextField(textField: UITextField){
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    //MARK: Resumen Delegate
    func setPopTrue() {
        self.numeroOrdenTextfield.placeholder = "Numero de orden:"
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

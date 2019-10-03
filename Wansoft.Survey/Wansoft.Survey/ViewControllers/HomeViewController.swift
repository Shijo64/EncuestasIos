//
//  HomeViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 25/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import SideMenu
import MaterialComponents
import CVCalendar

class HomeViewController: UIViewController, UITextFieldDelegate, BarcodeDelegate, ResumenDelegate, FechaDelegate {

    @IBOutlet weak var tipoEncuestaLabel: UILabel!
    @IBOutlet weak var iniciarButton: MDCButton!
    @IBOutlet weak var numeroOrdenTextfield: MDCTextField!
    @IBOutlet weak var codigoBarrasButton: MDCButton!
    @IBOutlet weak var fechaOrdenLabel: UILabel!
    @IBOutlet weak var fechaOrdenView: UIView!
    
    
    var encuesta:EncuestaModel?
    var encuestaSeleccionada:Bool = false
    var timer = Timer()
    var isTimerRunning = false
    var encuestasPendientes:[EncuestaBO]?
    var numeroOrdenController:MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.encuestaActualizada), name: NSNotification.Name(rawValue: "EncuestaActualizada"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.encuestaActualizada), name: NSNotification.Name(rawValue: "EncuestasActualizada"), object: nil)
        self.getEncuestaDefault()
        self.numeroOrdenTextfield.text = ""
        self.numeroOrdenController = MDCTextInputControllerOutlined(textInput: self.numeroOrdenTextfield)
        
        let logo = UIImage(named: "logo-completo")
        let buttonMenu = UIButton(type: .custom)
        buttonMenu.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        buttonMenu.setImage(logo, for: .normal)
        buttonMenu.setImage(logo, for: .highlighted)
        self.navigationItem.titleView = buttonMenu
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu))
        buttonMenu.addGestureRecognizer(longTap)
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.numeroOrdenTextfield.delegate = self
        self.view.addGestureRecognizer(tap)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.elegirFecha))
        self.fechaOrdenView.addGestureRecognizer(tapRecognizer)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: date)
        self.fechaOrdenLabel.text = dateString
        SharedData.sharedInstance.fechaOrden = date
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.buscarPendientes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        let codigoManual = SharedData.sharedInstance.codigoManual
        if(codigoManual == "true"){
            self.numeroOrdenTextfield.isUserInteractionEnabled = true
        }else{
            self.numeroOrdenTextfield.isUserInteractionEnabled = false
        }
        
        let codigoBarras = SharedData.sharedInstance.codigoBarras
        if(codigoBarras == "true"){
            self.codigoBarrasButton.isHidden = false
        }else{
            self.codigoBarrasButton.isHidden = true
        }
        
        SharedData.sharedInstance.dismissProgressIfVisible()
        self.numeroOrdenTextfield.resignFirstResponder()
    }
    
    func getEncuestaDefault(){
        let encuestaSelectGuardada = RealmHelper.sharedInstance.getObject(type: EncuestaSeleccionadaModel.self) as? EncuestaSeleccionadaModel
        if((encuestaSelectGuardada?.id)! > 0) {
            let predicado = "Id = \(encuestaSelectGuardada!.idEncuesta)"
            self.encuesta = (RealmHelper.sharedInstance.getObjectsWithPredicate(type: EncuestaModel.self, predicate: predicado)?.first as! EncuestaModel)
            SharedData.sharedInstance.idEncuestaSeleccionada = self.encuesta!.Id
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
    
    @objc func showMenu(){
        SharedData.sharedInstance.idEncuestaSeleccionada = self.encuesta!.Id
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! UISideMenuNavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func encuestaActualizada(not:Notification){
        self.encuesta = not.userInfo?["Encuesta"] as? EncuestaModel
        self.tipoEncuestaLabel.text = self.encuesta?.Name
    }
    
    @objc func buscarPendientes(){
        let network = NetworkHelper.sharedInstance
        let data = RealmHelper.sharedInstance.getObjects(type: EncuestaBO.self)
        self.encuestasPendientes = (data as! [EncuestaBO])
        if(((self.encuestasPendientes?.count)!) > 0){
            let manager = EncuestaManager()
            for encuesta in self.encuestasPendientes!{
                let predicate = "idEncuestaBO = \(encuesta.Id)"
                let respuestas = RealmHelper.sharedInstance.getObjectsWithPredicate(type: EncuestaRespuestas.self, predicate: predicate) as! [EncuestaRespuestas]
                if(network.reachability.connection == .cellular || network.reachability.connection == .wifi){
                    manager.sendEncuesta(encuesta: encuesta, respuestas: respuestas){ result in
                        let encuestaEnviada = EncuestaEnviadaModel()
                        encuestaEnviada.idEncuesta = encuesta.EncuestaId
                        encuestaEnviada.Id = encuestaEnviada.idIncrement()
                        RealmHelper.sharedInstance.deleteObjects(objects: respuestas)
                        RealmHelper.sharedInstance.deleteObject(object: encuesta)
                    }
                }
            }
        }

    }
    
    @IBAction func iniciarEncuesta(_ sender: Any) {
        if(self.numeroOrdenTextfield.text == ""){
            self.numeroOrdenController?.setErrorText("", errorAccessibilityValue: nil)
        }else{
            self.numeroOrdenController?.setErrorText(nil, errorAccessibilityValue: nil)
            SharedData.sharedInstance.numeroOrden = Int(self.numeroOrdenTextfield.text!)!
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            SharedData.sharedInstance.fechaOrden = formatter.date(from: self.fechaOrdenLabel.text!)!
            SharedData.sharedInstance.showProgress()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "EncuestaController") as! EncuestaViewController
            controller.encuesta = self.encuesta
            self.navigationController?.pushViewController(controller, animated: true)
            self.numeroOrdenTextfield.text = ""
        }
    }
    
    @IBAction func scanBarCode(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "barcodeController") as! BarCodeViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Barcode Delegate
    func sendCodigo(codigo: String) {
        let code = codigo
        var index = code.index(code.startIndex, offsetBy: 1)
        var endIndex = code.index(code.endIndex, offsetBy: -1)
        let newCode = code[index..<endIndex]
        index = newCode.index(newCode.startIndex, offsetBy: newCode.count-3)
        let numeroOrden = newCode[index...]
        self.numeroOrdenTextfield.text = String(numeroOrden)
        let fecha = newCode[..<index]
        endIndex = fecha.index(fecha.endIndex, offsetBy: -4)
        let diaMes = fecha[..<endIndex]
        let año = fecha[endIndex...]
        index = diaMes.index(diaMes.startIndex, offsetBy: 2)
        endIndex = diaMes.index(diaMes.endIndex, offsetBy: -2)
        let mes = diaMes[index...]
        let dia = diaMes[..<endIndex]
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = Int(dia)
        components.month = Int(mes)
        components.year = Int(año)
        
        let date = calendar.date(from: components)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: date!)
        self.fechaOrdenLabel.text = dateString
        
        self.numeroOrdenController?.setErrorText(nil, errorAccessibilityValue: nil)
    }
    
    func setEncuestaActualizada(encuesta: EncuestaModel) {
        self.encuesta = encuesta
        self.tipoEncuestaLabel.text = "Prueba"
    }
    
    //MARK: TEXTFIELD
    /*func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.numeroOrdenText
    }*/
    
    // Text Field is empty - show red border
    /*func errorHighlightTextField(textField: UITextField){
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }
    
    // Text Field is NOT empty - show gray border with 0 border width
    func removeErrorHighlightTextField(textField: UITextField){
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5
    }*/
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string != ""){
            self.numeroOrdenController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        return true
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
    
    func seleccionarFecha(fecha: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: fecha)
        self.fechaOrdenLabel.text = dateString
    }
    
    @objc func elegirFecha(){
        /*let view = UIView(frame: CGRect(x: 10, y: 150, width: self.view.frame.width - 20, height: self.view.frame.height * 0.5))
        view.backgroundColor = UIColor(white: 1, alpha: 0.95)
        self.view.addSubview(view)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 10, height: view.frame.height * 0.4))
        label.text = "Selecciona la fecha de la orden: "
        view.addSubview(label)
        let picker = UIDatePicker(frame: CGRect(x: 0, y: label.frame.height + 15, width: view.frame.width - 20, height: view.frame.height * 0.5))
        view.addSubview(picker)*/
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let fecha = formatter.date(from: self.fechaOrdenLabel.text!)!
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "fechaController") as! OrderDateViewController
        controller.delegate = self
        controller.currentDate = fecha
        self.present(controller, animated: true, completion: nil)
    }
}

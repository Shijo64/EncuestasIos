//
//  LoginViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 14/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController, UITextFieldDelegate {

    var codigoSucursal:String?
    
    @IBOutlet weak var codigoTextField: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codigoTextField.delegate = self
        self.passwordTextField.delegate = self
        let logo = UIImage(named: "logo-completo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.codigoTextField.text = SharedData.sharedInstance.login.idSucursal
        self.passwordTextField.text = SharedData.sharedInstance.login.password
    }
    
    @IBAction func EnviarCodigo(_ sender: Any) {
        if(self.codigoTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Aviso", message: "Es necesario introducir el código de la sucursal y la contraseña.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alertAction.setValue(UIColor(hexString: "#3E4883"), forKey: "titleTextColor")
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            SharedData.sharedInstance.showProgressWithMessage(message: "Por favor espera, \nIniciando Sesión...")
            self.codigoSucursal = self.codigoTextField.text
            let login = LoginModel()
            login.idSucursal = self.codigoSucursal!
            login.password = self.passwordTextField.text!
            let manager = EncuestaManager()
            
            let network = NetworkHelper.sharedInstance
            switch network.reachability.connection {
            case .none:
                SharedData.sharedInstance.progressError(message: "Por favor revisa la conexión")
                break
            default:
                manager.getEncuestas(login: login){
                    result in
                    if(result.MessageType == 1){
                        RealmHelper.sharedInstance.saveObject(object: login)
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "mainNavigationController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = controller
                        self.present(controller!, animated: true, completion:{
                            SharedData.sharedInstance.dismissProgressHud()
                        })
                    }else{
                        let alert = UIAlertController(title: "Aviso", message: result.Message, preferredStyle: .alert)
                        let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                        action.setValue(UIColor(hexString: "#3E4883"), forKey: "titleTextColor")
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.tag == 0){
            self.passwordTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

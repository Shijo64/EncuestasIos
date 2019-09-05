//
//  MenuTableViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 22/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var vistaCelda1: UIView!
    @IBOutlet weak var vistaCelda2: UIView!
    @IBOutlet weak var vistaCelda3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dismissKeyboard()
        /*let backgroundImage = UIImage(named: "restaurant-desk")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        self.tableView.backgroundView = imageView*/
    }

    func limpiarBaseDatos(){
        RealmHelper.sharedInstance.deleteDatabase()
    }
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }*/

    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = "Cambiar sucursal"

        return cell
    }*/
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let controller = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
            dismiss(animated: true, completion: {
                controller.popToRootViewController(animated: true)
            })
        }
        else if(indexPath.row == 1){
            self.showSucursalAlert(){
                result in
                if(result){
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "encuestasController")
                    self.navigationController?.pushViewController(controller!, animated: true)
                }else{
                    let message = "Necesitas el id de la sucursal para ver las encuestas"
                    self.showErrorCodigoSucursal(message: message)
                }
            }
        }
        else if(indexPath.row == 2){
            self.showSucursalAlert(){
                result in
                if (result){
                    var currentLogin = RealmHelper.sharedInstance.getObject(type: LoginModel.self) as! LoginModel
                    SharedData.sharedInstance.login.idSucursal = currentLogin.idSucursal
                    SharedData.sharedInstance.login.password = currentLogin.password
                    SharedData.sharedInstance.showProgress()
                    self.dismiss(animated: true, completion: {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "startNavigationController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = controller
                        self.navigationController?.popToRootViewController(animated: true)
                        self.limpiarBaseDatos()
                        SharedData.sharedInstance.dismissProgressHud()
                    })
                }else{
                    let message = "Necesitas el id de la sucursal para poder cambiar de sucursal"
                    self.showErrorCodigoSucursal(message: message)
                }
            }
        }
        else if(indexPath.row == 3){
            self.showSucursalAlert(){
                result in
                if(result){
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "configuracionController")
                    self.navigationController?.pushViewController(controller!, animated: true)
                }else{
                    let message = "Necesitas el id de la sucursal para poder entrar a la configuración"
                    self.showErrorCodigoSucursal(message: message)
                }
            }
        }
        else if(indexPath.row == 4){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "acercaDeController")
            self.navigationController?.pushViewController(controller!, animated: true)
        }
    }
    
    func showSucursalAlert(completionHandler:@escaping(Bool) -> ()){
        let alert = UIAlertController(title: "Sucursal", message: "Introduce el id de sucursal para ingresar a la configuración", preferredStyle: .alert)
        alert.addTextField{ (textfield) in
            textfield.placeholder = "Código sucursal"
        }
        let aceptarAction = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) in
            let codigo = alert.textFields![0].text
            let login = RealmHelper.sharedInstance.getObject(type: LoginModel.self) as! LoginModel
            if(codigo == login.idSucursal){
                completionHandler(true)
            }else{
                completionHandler(false)
            }
        })
        aceptarAction.setValue(UIColor(hexString: "#3E4883"), forKey: "titleTextColor")
        let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        cancelarAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(aceptarAction)
        alert.addAction(cancelarAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorCodigoSucursal(message:String){
        let alert = UIAlertController(title: "Sucursal", message: message, preferredStyle: .alert)
        let aceptarAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        aceptarAction.setValue(UIColor(hexString: "#3E4883"), forKey: "titleTextColor")
        alert.addAction(aceptarAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

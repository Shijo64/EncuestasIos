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
        
        let logo = UIImage(named: "logo-completo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dismissKeyboard()
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
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0 && indexPath.row == 0){
            let controller = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
            dismiss(animated: true, completion: {
                controller.popToRootViewController(animated: true)
            })
        }
        else if(indexPath.section == 2 && indexPath.row == 0){
            self.dismiss(animated: true, completion: {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "startNavigationController")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = controller
                self.navigationController?.popToRootViewController(animated: true)
                self.limpiarBaseDatos()
            })
        }
        else if(indexPath.section == 3 && indexPath.row == 0){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "configuracionController")
            self.navigationController?.pushViewController(controller!, animated: true)
        }
        else if(indexPath.section == 4 && indexPath.row == 0){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "acercaDeController")
            self.navigationController?.pushViewController(controller!, animated: true)
        }
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

//
//  ConfiguracionTableViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Jaime Leija Morales on 28/05/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit

class ConfiguracionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(indexPath.row == 0){
            if(SharedData.sharedInstance.ordenManual){
                SharedData.sharedInstance.ordenManual = false
                cell?.accessoryType = .none
            }else{
                SharedData.sharedInstance.ordenManual = true
                cell?.accessoryType = .checkmark
            }
        }else{
            if(SharedData.sharedInstance.barcodeActivo){
                SharedData.sharedInstance.barcodeActivo = false
                cell?.accessoryType = .none
            }else{
                SharedData.sharedInstance.barcodeActivo = true
                cell?.accessoryType = .checkmark
            }
        }
        
        UserDefaults.standard.set("\(SharedData.sharedInstance.barcodeActivo)", forKey: "barcodeActivo")
        UserDefaults.standard.set(SharedData.sharedInstance.ordenManual, forKey: "ordenConfig")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "nordenCell")
            if(SharedData.sharedInstance.ordenManual){
                cell?.accessoryType = .checkmark
            }else{
                cell?.accessoryType = .none
            }
            
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "codigoCell")
            if(SharedData.sharedInstance.barcodeActivo){
                cell?.accessoryType = .checkmark
            }else{
                cell?.accessoryType = .none
            }
            
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

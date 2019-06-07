//
//  EncuestasTableViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 16/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import RealmSwift
import PPBadgeViewSwift
import SideMenu

class EncuestasTableViewController: UITableViewController {
    
    var encuestas:[EncuestaModel]?
    var refresh = UIRefreshControl()
    var encuestasPendientes:[EncuestaBO]?
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logo-completo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        
        self.refresh.attributedTitle = NSAttributedString(string: "Descargando actualizaciones")
        self.refresh.addTarget(self, action: #selector(self.buscarActualizaciones), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refresh
        } else {
            self.tableView.addSubview(self.refresh)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.encuestas = SharedData.sharedInstance.sucursal?.Encuestas
        let backgroundImage = UIImage(named: "restaurant-desk")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        self.tableView.backgroundView = imageView
        let data = RealmHelper.sharedInstance.getObjects(type: EncuestaModel.self)
        self.encuestas = (data as! [EncuestaModel])
        self.tableView.reloadData()
        self.buscarPendientes()
    }
    
    @objc func buscarActualizaciones(){
        let network = NetworkHelper.sharedInstance
        switch network.reachability.connection {
        case .none:
            SharedData.sharedInstance.progressError(message: "Por favor revisa la conexión")
            self.refresh.endRefreshing()
            break
        default:
            let result = RealmHelper.sharedInstance.getObject(type: LoginModel.self) as! LoginModel
            /*let login = LoginModel()
            login.idSucursal = result.idSucursal
            login.password = result.password*/
            //RealmHelper.sharedInstance.deleteDatabase()
            //RealmHelper.sharedInstance.deleteEncuestas()
            let manager = EncuestaManager()
            manager.getEncuestas(login: result){
                result in
                if(result){
                    //RealmHelper.sharedInstance.saveObject(object: login)
                    //RealmHelper.sharedInstance.guardarEncuestas(encuestas: result.Encuestas)
                    self.encuestas = (RealmHelper.sharedInstance.getObjects(type: EncuestaModel.self) as! [EncuestaModel])
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                }
            }
            break
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
            /*if(((self.encuestasPendientes?.count)!) > 0){
                let manager = EncuestaManager()
                for encuesta in self.encuestasPendientes!{
                    let predicate = "idEncuestaBO = \(encuesta.Id)"
                    let respuestas = RealmHelper.sharedInstance.getObjectsWithPredicate(type: EncuestaRespuestas.self, predicate: predicate) as! [EncuestaRespuestas]
                    manager.sendEncuesta(encuesta: encuesta, respuestas: respuestas){ result in
                        RealmHelper.sharedInstance.deleteObjects(objects: respuestas)
                    }
                }
                RealmHelper.sharedInstance.deleteObjects(objects: self.encuestasPendientes!)
            }*/
        }
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.darkGray
        cell.alpha = 0.75
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.encuestas?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let encuesta = self.encuestas![indexPath.section]
        let pendientes = self.encuestasPendientes?.filter{$0.EncuestaId == encuesta.Id}
        let cell = tableView.dequeueReusableCell(withIdentifier: "encuestaCell", for: indexPath) as! EncuestaTableViewCell
        cell.configureCell(encuesta: encuesta, pendientes: (pendientes?.count)!)
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RealmHelper.sharedInstance.deleteEncuestasSeleccionadas()
        let encuestaSeleccionada = self.encuestas![indexPath.section]
        let encuestaSelect = EncuestaSeleccionadaModel()
        encuestaSelect.id = 1
        encuestaSelect.idEncuesta = encuestaSeleccionada.Id
        RealmHelper.sharedInstance.saveObject(object: encuestaSelect)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "homeController") as! HomeViewController
        controller.encuesta = encuestaSeleccionada
        controller.encuestaSeleccionada = true
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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

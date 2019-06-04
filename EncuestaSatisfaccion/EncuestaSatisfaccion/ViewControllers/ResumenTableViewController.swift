//
//  ResumenTableViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 28/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import KRProgressHUD

class ResumenTableViewController: UITableViewController {

    var encuesta:EncuestaModel?
    var preguntas:[PreguntaModel] = []
    var respuestas:[EncuestaRespuestas]?
    var encuestaEnviar:EncuestaBO?
    
    weak var delegate:ResumenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "logo-completo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.respuestas = SharedData.sharedInstance.respuestas
        self.encuestaEnviar = EncuestaBO()
        for pregunta in (self.encuesta?.Questions)!{
            self.preguntas.append(pregunta)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.isMovingFromParent){
            delegate?.setPopTrue()
        }
    }
    
    @objc func enviarEncuesta(){
        let encuestaBO = EncuestaBO()//SharedData.sharedInstance.encuestaBO
        encuestaBO.EncuestaId = (self.encuesta?.Id)!
        encuestaBO.Id = encuestaBO.idIncrement()
        encuestaBO.nombreEncuesta = (self.encuesta?.Name)!
        encuestaBO.CodigoEncuesta = (self.encuesta?.Name)!
        encuestaBO.Orden = SharedData.sharedInstance.numeroOrden
        
        var respuestasEnviar:[EncuestaRespuestas] = []
        for respuesta in self.respuestas!{
            respuesta.idEncuestaBO = encuestaBO.Id
            respuesta.Id = respuesta.idIncrement()
            respuestasEnviar.append(respuesta)
            RealmHelper.sharedInstance.saveObject(object: respuesta)
        }
        RealmHelper.sharedInstance.saveObject(object: encuestaBO)
        
        let network = NetworkHelper.sharedInstance
        
        switch network.reachability.connection {
        case .none:
            
            let alert = UIAlertController(title: "Aviso", message: "Hubo un problema, revisa la conexión e intenta de nuevo.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Aceptar", style: .default, handler: {UIAlertAction in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: {
                SharedData.sharedInstance.respuestas = []
            })
            break
        default:
            let manager = EncuestaManager()
            KRProgressHUD.show()
            manager.sendEncuesta(encuesta: encuestaBO, respuestas: respuestasEnviar){result in
                if(result.response?.statusCode == 200){
                    KRProgressHUD.showSuccess(withMessage: "La encuesta fue enviada con éxito.")
                    RealmHelper.sharedInstance.deleteObject(object: encuestaBO)
                    RealmHelper.sharedInstance.deleteObjects(objects: respuestasEnviar)
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "envioViewController")
                    self.navigationController?.pushViewController(controller!, animated: true)
                }else{
                    KRProgressHUD.showError(withMessage: "Hubo un problema, porfavor intenta de nuevo")
                }
            }
            break
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.respuestas?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let respuesta = self.respuestas![section]
        if (respuesta.arrayRespuestas.count > 0){
            return respuesta.arrayRespuestas.count
        }else{
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pregunta = self.preguntas[indexPath.section]
        var opciones:[OpcionesPreguntaModel] = []
        for opcion in (pregunta.AnswerOptions){
            opciones.append(opcion)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "resumenCell", for: indexPath)
        let respuesta = self.respuestas![indexPath.section]
        if(opciones.count > 0){
            if(respuesta.arrayRespuestas.count > 0){
                let respuestaAdded = respuesta.arrayRespuestas[indexPath.row]
                let respuestaOpcion = opciones.first(where: {$0.Id == Int(respuestaAdded)})
                cell.textLabel?.text = respuestaOpcion?.Description
            }else{
                let respuestaOpcion = opciones.first(where: {$0.Id == Int(respuesta.respuesta)})
                cell.textLabel?.text = respuestaOpcion?.Description
            }
        }else{
            cell.textLabel?.text = respuesta.respuesta
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(self.encuestaEnviar?.Id != nil){
            let pregunta = self.preguntas[section]
            return pregunta.Description
        }else{
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(section == (self.respuestas?.count)! - 1){
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 80))
            let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: footerView.frame.width * 0.80, height:footerView.frame.height))
            sendButton.center = footerView.center
            sendButton.backgroundColor = UIColor.flatSkyBlue()
            sendButton.layer.cornerRadius = 15
            sendButton.setTitle("Enviar", for: .normal)
            sendButton.addTarget(self, action: #selector(self.enviarEncuesta), for: .touchUpInside)
            footerView.addSubview(sendButton)
            return footerView
        }else{
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == (self.respuestas?.count)! - 1){
            return 80
        }else{
            return 0
        }
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

//MARK: Class Protocol
protocol ResumenDelegate:class{
    func setPopTrue()
}

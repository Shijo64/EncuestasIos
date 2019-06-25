//
//  DetallePendienteViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 22/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit

class DetallePendienteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var respuestas:[EncuestaRespuestas]?
    var encuestaGuardada:EncuestaBO?
    var encuesta:EncuestaModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enviarPendienteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "logo-completo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.enviarPendienteButton.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*let predicate = "id = \((self.encuestaGuardada?.idEncuesta)!)"
        let result = RealmHelper.sharedInstance.getObjectsWithPredicate(type: EncuestaModel.self, predicate: predicate)
        self.encuesta = (result?.first as! EncuestaModel)
        let predicateRespuestas = "idEncuesta = \((self.encuestaGuardada?.idEncuesta)!)"
        //self.encuesta?.Questions = (RealmHelper.sharedInstance.getObjectsWithPredicate(type: PreguntaModel.self, predicate: predicateRespuestas) as! [PreguntaModel])*/
    }
    
    @IBAction func enviarPendiente(_ sender: Any) {
        let manager = EncuestaManager()
        /*manager.sendEncuesta(){result in
            if(result == 200){
                let alertController = UIAlertController(title: "Aviso", message: "La encuesta fue contestada con exito, muchas gracias por participar", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Aceptar", style: .default, handler: {UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                    self.removerEncuestaPendiente()
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: {
                    SharedData.sharedInstance.respuestas = []
                })
            }
        }*/
    }
    
    func removerEncuestaPendiente(){
        RealmHelper.sharedInstance.deleteObject(object: self.encuestaGuardada!)
        RealmHelper.sharedInstance.deleteObjects(objects: self.respuestas!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.respuestas?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let respuesta = self.respuestas![indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "respuestaCell")
        cell?.textLabel?.text = respuesta.respuesta
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*if(self.encuesta?.idSucursal != nil){
            let pregunta = self.encuesta?.preguntas![section]
            return pregunta?.textoPregunta
        }else{
            return ""
        }*/
        return ""
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

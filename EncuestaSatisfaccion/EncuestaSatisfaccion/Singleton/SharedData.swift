//
//  SharedData.swift
//  EncuestaSatisfaccion
//
//  Created by Andrea Merodio on 10/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import Foundation
import KRProgressHUD

class SharedData{
    //var sucursal:SucursalModel?
    var respuestas:[EncuestaRespuestas] = []
    var encuestaBO:EncuestaBO = EncuestaBO()
    var numeroOrden:Int = 0
    var user:String = ""
    var password:String = ""
    var font = UIFont(name: "Graphik-Regular.ttf", size: UIFont.systemFontSize)
    var ordenManual = false
    var fechaOrden = Date()
    
    static let sharedInstance = SharedData()
    
    private init(){}
    
    func showProgress(){
        KRProgressHUD.set(maskType: .black)
        let color1 = UIColor.red
        let color2 = UIColor.yellow
        KRProgressHUD.set(activityIndicatorViewColors: [color1, color2])
        KRProgressHUD.show(withMessage: "Cargando...", completion: nil)
    }
    
    func dismissProgressIfVisible(){
        if(KRProgressHUD.isVisible){
            KRProgressHUD.dismiss()
        }
    }
    
    func dismissProgressHud(){
        KRProgressHUD.dismiss()
    }
    
    func progressError(message:String){
        KRProgressHUD.showError(withMessage: message)
    }
    
    func progressSuccess(){
        KRProgressHUD.showSuccess(withMessage: "Carga exitosa")
    }
}

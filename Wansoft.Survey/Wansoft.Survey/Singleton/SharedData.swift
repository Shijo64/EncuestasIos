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
    var fechaOrden = Date()
    var login = LoginModel()
    var codigoManual = ""
    var codigoBarras = ""
    var idEncuestaSeleccionada = 0
    
    static let sharedInstance = SharedData()
    
    private init(){}
    
    func showProgress(){
        KRProgressHUD.set(maskType: .black)
        KRProgressHUD.set(style: KRProgressHUDStyle.black)
        let color1 = UIColor.white
        let color2 = UIColor.white
        KRProgressHUD.set(activityIndicatorViewColors: [color1, color2])
        KRProgressHUD.show(withMessage: "Cargando...", completion: nil)
    }
    
    func showProgressWithMessage(message:String){
        KRProgressHUD.set(maskType: .black)
        KRProgressHUD.set(style: KRProgressHUDStyle.black)
        let color1 = UIColor.white
        let color2 = UIColor.white
        
        KRProgressHUD.set(activityIndicatorViewColors: [color1, color2])
        KRProgressHUD.show(withMessage: message, completion: nil)
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
        KRProgressHUD.set(maskType: .black)
        KRProgressHUD.set(style: KRProgressHUDStyle.black)
        let color1 = UIColor.white
        let color2 = UIColor.white
        KRProgressHUD.set(activityIndicatorViewColors: [color1, color2])
        KRProgressHUD.showError(withMessage: message)
    }
    
    func progressSuccess(){
        KRProgressHUD.set(maskType: .black)
        KRProgressHUD.set(style: KRProgressHUDStyle.black)
        let color1 = UIColor.white
        let color2 = UIColor.white
        KRProgressHUD.set(activityIndicatorViewColors: [color1, color2])
        KRProgressHUD.showSuccess(withMessage: "Carga exitosa")
    }
}

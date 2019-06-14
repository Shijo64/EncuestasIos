//
//  EncuestaBO.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 21/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class EncuestaBO: Object, Mappable {
    @objc dynamic var Id = 0
    @objc dynamic var CodigoEncuesta = ""
    @objc dynamic var Orden = 0
    @objc dynamic var FechaOperacion = Date()
    @objc dynamic var EncuestaId = 0
    @objc dynamic var nombreEncuesta = ""
    @objc dynamic var FechaRegistro = Date()
    @objc dynamic var FechaOrden = Date()
    var respuestas:[EncuestaRespuestas] = []
    
    override static func primaryKey() -> String? {
        return "Id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func idIncrement() -> Int{
        let retNext = RealmHelper.sharedInstance.getObjects(type: EncuestaBO.self)
        var encuestas = retNext as! [EncuestaBO]
        if(encuestas.count > 0){
            encuestas = encuestas.sorted(by: {$0.Id < $1.Id})
            let last = encuestas.last
            let value = last?.Id
            return value! + 1
        }else{
            return 0
        }
    }
    
    func mapping(map: Map) {
        if map.mappingType == .toJSON {
            var id = self.Id
            id <- map["Id"]
        } else {
            self.Id <- map["Id"]
        }
        //var id = self.Id
        //self.Id <- map["Id"]
        self.CodigoEncuesta <- map["CodigoEncuesta"]
        self.Orden <- map["Orden"]
        self.FechaOperacion <- (map["FechaOperacion"], DateTransform())
        self.EncuestaId <- map["EncuestaId"]
        self.FechaRegistro <- (map["FechaRegistro"], DateTransform())
        self.FechaOrden <- (map["FechaOrden"], DateTransform())
        self.respuestas <- map["Respuestas"]
    }
}

//
//  EncuestaRespuestas.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 11/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class EncuestaRespuestas: Object, Mappable {
    
    @objc dynamic var Id = 0
    @objc dynamic var idEncuestaBO = 0
    @objc dynamic var idEncuesta = 0
    @objc dynamic var idPregunta = 0
    @objc dynamic var numeroPregunta = 0
    @objc dynamic var respuesta = ""
    let arrayRespuestas = List<String>()
    
    override static func primaryKey() -> String? {
        return "Id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func idIncrement() -> Int{
        let retNext = RealmHelper.sharedInstance.getObjects(type: EncuestaRespuestas.self)
        var encuestas = retNext as! [EncuestaRespuestas]
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
        
        /*var id = self.Id
        id <- map["Id"]*/
        self.idEncuestaBO <- map["ResultadoEncuestaId"]
        self.idEncuesta <- map["EncuestaId"]
        self.idPregunta <- map["PreguntaEncuestaId"]
        self.numeroPregunta <- map["NumeroPregunta"]
        self.respuesta <- map["Respuesta"]
        var array:[String]?
        array <- map["arrayRespuestas"]
        if let array = array{
            for data in array{
                self.arrayRespuestas.append(data)
            }
        }
    }
}

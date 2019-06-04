//
//  DetalleResultadoEncuesta.swift
//  EncuestaSatisfaccion
//
//  Created by Jaime Leija Morales on 08/02/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import ObjectMapper

class DetalleResultadoEncuesta: NSObject, Mappable{
    var Id = 0
    var idEncuestaBO = 0
    var idEncuesta = 0
    var idPregunta = 0
    var numeroPregunta = 0
    var respuesta = ""
    var arrayRespuestas:[String] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.Id <- map["Id"]
        self.idEncuestaBO <- map["SurveyResultId"]
        //self.idEncuesta <- map["EncuestaId"]
        self.idPregunta <- map["QuestionId"]
        //self.numeroPregunta <- map["NumeroPregunta"]
        self.respuesta <- map["Answer"]
    }
}

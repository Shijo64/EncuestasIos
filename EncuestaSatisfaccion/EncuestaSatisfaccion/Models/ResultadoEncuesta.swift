//
//  ResultadoEncuesta.swift
//  EncuestaSatisfaccion
//
//  Created by Jaime Leija Morales on 08/02/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import ObjectMapper

class ResultadoEncuesta: NSObject, Mappable {
    var Id = 0
    var CodigoEncuesta = ""
    var Orden = 0
    var FechaOperacion = Date()
    var EncuestaId = 0
    var nombreEncuesta = ""
    var FechaRegistro = Date()
    var respuestas:[DetalleResultadoEncuesta] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.Id <- map["Id"]
        self.CodigoEncuesta <- map["SurveyCode"]
        self.Orden <- map["Order"]
        self.FechaOperacion <- (map["OperationDate"], DateFormatterTransform(dateFormatter: dateFormatter))
        self.EncuestaId <- map["SurveyId"]
        self.FechaRegistro <- (map["RegistrationDate"], DateFormatterTransform(dateFormatter: dateFormatter))
        self.respuestas <- map["SurveyDetailResultList"]
    }
}

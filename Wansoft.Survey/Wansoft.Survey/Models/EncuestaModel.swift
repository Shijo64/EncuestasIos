//
//  Encuesta.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 10/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class EncuestaModel:Object, Mappable{
    @objc dynamic var Id = 0
    @objc dynamic var Name:String?
    @objc dynamic var CreationDate:Date?
    @objc dynamic var Status = 0
    @objc dynamic var Default = false
    var Questions = List<PreguntaModel>()
    
    override static func primaryKey() -> String? {
        return "Id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map:Map){
        self.Id <- map["Id"]
        self.Name <- map["Name"]
        self.CreationDate <- map["CreationDate"]
        self.Status <- map["Status"]
        self.Default <- map["Default"]
        var questions:[PreguntaModel]?
        questions <- map["Questions"]
        if let questions = questions{
            for question in questions{
                self.Questions.append(question)
            }
        }
    }
}


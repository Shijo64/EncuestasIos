//
//  PreguntaModel.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 10/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class PreguntaModel:Object, Mappable{
    @objc dynamic var Id = 0
    @objc dynamic var SurveyId = 0
    @objc dynamic var Description = ""
    @objc dynamic var Order = 0
    @objc dynamic var Status = 0
    @objc dynamic var QuestionType:TipoPreguntaModel?
    @objc dynamic var Optional = false
    let AnswerOptions = List<OpcionesPreguntaModel>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.Id <- map["Id"]
        self.SurveyId <- map["SurveyId"]
        self.Description <- map["Description"]
        self.Order <- map["Order"]
        self.Status <- map["Status"]
        self.QuestionType <- map["QuestionType"]
        self.Optional <- map["Optional"]
        var options:[OpcionesPreguntaModel]?
        options <- map["AnswerOptions"]
        if let options = options{
            for option in options{
                self.AnswerOptions.append(option)
            }
        }
    }
}

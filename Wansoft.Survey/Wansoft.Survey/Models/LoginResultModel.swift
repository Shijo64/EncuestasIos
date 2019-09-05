//
//  LoginResultModel.swift
//  Wansoft.Survey
//
//  Created by Arturo Calvo on 8/2/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class LoginResultModel: Object, Mappable {
    @objc dynamic var MessageType = 0
    @objc dynamic var Message = ""
    let surveyList = List<EncuestaModel>()
    var respuestas:[EncuestaRespuestas] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //var id = self.Id
        //self.Id <- map["Id"]
        self.MessageType <- map["MessageType"]
        self.Message <- map["Message"]
        var surveys:[EncuestaModel]?
        surveys <- map["surveyList"]
        if let surveys = surveys{
            for survey in surveys{
                self.surveyList.append(survey)
            }
        }
    }
}

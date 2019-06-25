//
//  OpcionesPreguntaModel.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 30/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class OpcionesPreguntaModel: Object, Mappable {
    @objc dynamic var Id = 0
    @objc dynamic var QuestionId = 0
    @objc dynamic var Description = ""
    @objc dynamic var Order = 0
    @objc dynamic var Status = 0
    @objc dynamic var Default = false
    @objc dynamic var Value = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map:Map){
        self.Id <- map["Id"]
        self.QuestionId <- map["QuestionId"]
        self.Description <- map["Description"]
        self.Order <- map["Order"]
        self.Status <- map["Status"]
        self.Default <- map["Default"]
        self.Value <- map["Value"]
    }
}

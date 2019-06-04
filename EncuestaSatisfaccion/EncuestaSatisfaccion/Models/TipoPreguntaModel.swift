//
//  TipoPreguntaModel.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 30/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class TipoPreguntaModel: Object, Mappable {
    @objc dynamic var Id = 0
    @objc dynamic var Description = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.Id <- map["Id"]
        self.Description <- map["Description"]
    }
}

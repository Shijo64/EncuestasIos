//
//  SucursalModel.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 14/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import ObjectMapper

class SucursalModel:Mappable{
    var Encuestas:[EncuestaModel] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.Encuestas <- map["Encuestas"]
    }
}

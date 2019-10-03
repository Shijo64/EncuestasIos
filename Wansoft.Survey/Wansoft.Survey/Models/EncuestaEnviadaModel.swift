//
//  EncuestaEnviadaModel.swift
//  Wansoft.Survey
//
//  Created by Arturo Calvo on 9/11/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import Foundation
import RealmSwift

class EncuestaEnviadaModel:Object{
    @objc dynamic var Id = 0
    @objc dynamic var idEncuesta = 0
    
    override static func primaryKey() -> String? {
        return "Id"
    }
    
    func idIncrement() -> Int{
        let retNext = RealmHelper.sharedInstance.getObjects(type: EncuestaEnviadaModel.self)
        var encuestas = retNext as! [EncuestaEnviadaModel]
        if(encuestas.count > 0){
            encuestas = encuestas.sorted(by: {$0.Id < $1.Id})
            let last = encuestas.last
            let value = last?.Id
            return value! + 1
        }else{
            return 0
        }
    }
}

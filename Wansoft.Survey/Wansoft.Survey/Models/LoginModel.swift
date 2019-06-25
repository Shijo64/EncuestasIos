//
//  LoginModel.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 17/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import RealmSwift

class LoginModel:Object {
    @objc dynamic var idSucursal = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "idSucursal"
    }
}

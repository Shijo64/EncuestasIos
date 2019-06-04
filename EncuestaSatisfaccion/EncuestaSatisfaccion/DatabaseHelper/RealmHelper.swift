//
//  RealmHelper.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 17/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper{
    private var database:Realm
    
    static let sharedInstance = RealmHelper()
    
    private init(){
        self.database = try! Realm()
    }
    
    func saveObject(object: Object){
        try? database.write {
            database.add(object)
        }
    }
    
    func getObject(type: Object.Type) -> Object{
        let result = self.database.objects(type)
        if(result.count > 0){
            return result.first!
        }else{
            let result = type.init()
            return result
        }
    }
    
    func saveArray(array:[Object]){
        for object in array{
            self.saveObject(object: object)
        }
    }
    
    func getObjects(type:Object.Type) -> [Object]?{
        let data = database.objects(type)
        var result:[Object] = []
        for object in data{
            result.append(object)
        }
        return result
    }
    
    func getObjectsWithPredicate(type:Object.Type, predicate:String) -> [Object]?{
        let data = database.objects(type).filter(predicate)
        var result:[Object] = []
        for object in data{
            result.append(object)
        }
        return result
    }
    
    func deleteObject(object:Object){
        try! database.write {
            database.delete(object)
        }
    }
    
    func deleteObjects(objects:[Object]){
        for object in objects{
            try! database.write {
                database.delete(object)
            }
        }
    }
    
    /*func prueba(){
        let encuestas = database.objects(EncuestaModel.self)
        let preguntas = database.objects(PreguntaModel.self)
        let tipoPreguntas = database.objects(TipoPreguntaModel.self)
        let opcionesPregunta = database.objects(OpcionesPreguntaModel.self)
        let encuestaRespuestas = database.objects(EncuestaRespuestas.self)
        let encuestaBO = database.objects(EncuestaBO.self)
        
        try! database.write{
            database.delete(encuestas)
            database.delete(preguntas)
            database.delete(tipoPreguntas)
            database.delete(opcionesPregunta)
            database.delete(encuestaRespuestas)
            database.delete(encuestaBO)
        }
    }*/
    
    func deleteEncuestas(){
        let encuestas = database.objects(EncuestaModel.self)
        /*let preguntas = database.objects(PreguntaModel.self)
        let tipoPreguntas = database.objects(TipoPreguntaModel.self)
        let opcionesPregunta = database.objects(OpcionesPreguntaModel.self)*/
        try! database.write {
            database.delete(encuestas)
            /*database.delete(preguntas)
            database.delete(tipoPreguntas)
            database.delete(opcionesPregunta)*/
        }
    }
    
    func deleteEncuestasSeleccionadas(){
        let encuestas = database.objects(EncuestaSeleccionadaModel.self)
        if(encuestas.count > 0){
            try! database.write {
                database.delete(encuestas)
            }
        }
    }
    
    func deleteDatabase(){
        try! database.write {
            database.deleteAll()
        }
    }
    
    func updateEncuestas(encuestas:[EncuestaModel]){
        let encuestasGuardadas = database.objects(EncuestaModel.self)
        try! database.write {
            database.delete(encuestasGuardadas)
            for encuesta in encuestas{
                database.add(encuesta)
            }
        }
    }
    
    func guardarEncuestas(encuestas:[EncuestaModel]){
        for encuesta in encuestas{
            self.saveObject(object: encuesta)
            for pregunta in encuesta.Questions{
                self.saveObject(object: pregunta)
            }
        }
    }
}

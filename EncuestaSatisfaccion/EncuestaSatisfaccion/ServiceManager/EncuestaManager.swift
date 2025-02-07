//
//  EncuestaManager.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 10/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift

public class EncuestaManager{
    func getEncuestas(login:LoginModel, completionHandler:@escaping(Bool) -> ()){
        //LLamada Alamofire
        let url = "https://demo7042471.mockable.io/getEncuestas"
        let urlProduccion = "https://www.wansoft.net/wansoft.web/app/GetSurveyList?subsidiaryId=\(login.idSucursal)&subsidiaryPassword=\(login.password)"
        
        Alamofire.request(urlProduccion).responseJSON {response in
            if let result = response.result.value as? [String:Any] {
                if let callResult = result["Success"]{
                    let message = result["Message"] as! String
                    SharedData.sharedInstance.progressError(message: message)
                }
            }else{
                let jsonArray = response.result.value as! [[String:Any]]
                let encuestas = Mapper<EncuestaModel>().mapArray(JSONArray: jsonArray)
                var encuestasFiltradas:[EncuestaModel] = []
                for encuesta in encuestas{
                    var preguntasLista:List<PreguntaModel> = List<PreguntaModel>()
                    var sortedPreguntas:[PreguntaModel] = []
                    for pregunta in encuesta.Questions{
                        sortedPreguntas.append(pregunta)
                    }
                    let preguntas = sortedPreguntas.sorted(by: { $0.Order < $1.Order })
                    for pregunta in preguntas{
                        if(pregunta.Status == 1){
                            preguntasLista.append(pregunta)
                        }
                    }
                    encuesta.Questions = preguntasLista
                    encuestasFiltradas.append(encuesta)
                }
                
                RealmHelper.sharedInstance.updateEncuestas(encuestas: encuestasFiltradas)
                //RealmHelper.sharedInstance.guardarEncuestas(encuestas: encuestasFiltradas)
                completionHandler(true)
            }
        }
    }
    
    func sendEncuesta(encuesta:EncuestaBO, respuestas:[EncuestaRespuestas], completionHandler:@escaping(DataResponse<Any>) -> ())
    {
        let url = "https://www.wansoft.net/wansoft.web/app/SaveSurveyResponses"
        
        let encuestaEnviar = ResultadoEncuesta()
        encuestaEnviar.Id = encuesta.Id
        encuestaEnviar.CodigoEncuesta = encuesta.CodigoEncuesta
        encuestaEnviar.EncuestaId = encuesta.EncuestaId
        encuestaEnviar.FechaOperacion = encuesta.FechaOperacion
        encuestaEnviar.FechaRegistro = encuesta.FechaRegistro
        encuestaEnviar.nombreEncuesta = encuesta.nombreEncuesta
        encuestaEnviar.Orden = encuesta.Orden
        var respuestasEnviar:[DetalleResultadoEncuesta] = []
        for respuesta in respuestas{
            let respuestaEnviar = DetalleResultadoEncuesta()
            respuestaEnviar.Id = respuesta.Id
            respuestaEnviar.idEncuesta = respuesta.idEncuesta
            respuestaEnviar.idEncuestaBO = respuesta.idEncuestaBO
            respuestaEnviar.idPregunta = respuesta.idPregunta
            respuestaEnviar.numeroPregunta = respuesta.numeroPregunta
            respuestaEnviar.respuesta = respuesta.respuesta
            respuestasEnviar.append(respuestaEnviar)
        }
        encuestaEnviar.respuestas = respuestasEnviar
        let jsonServicio = encuestaEnviar.toJSONString(prettyPrint: true)
        
        let login = RealmHelper.sharedInstance.getObject(type: LoginModel.self) as! LoginModel
        
        let parameters:Parameters = ["subsidiaryId":login.idSucursal,
                                     "subsidiaryPassword":login.password,
                                     "result":jsonServicio!]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON(){ response in
            print(response.result)
            print(response)
            completionHandler(response)
        }
    }
    
    /*func sendEncuestasPendientes(pendientes:[EncuestaBO], completionHandler:@escaping(Int) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            for encuesta in pendientes{
                let predicate = "idEncuestaBO = \(encuesta.id)"
                let respuestas = RealmHelper.sharedInstance.getObjectsWithPredicate(type: EncuestaRespuestas.self, predicate: predicate)
                encuesta.respuestas = respuestas as! [EncuestaRespuestas]
                self.sendEncuesta(encuesta: encuesta){ result in
                    
                }
            }
            completionHandler(200)
        })
    }*/
}

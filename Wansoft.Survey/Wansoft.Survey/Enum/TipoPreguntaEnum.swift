//
//  TipoPreguntaEnum.swift
//  EncuestaSatisfaccion
//
//  Created by Andrea Merodio on 11/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import Foundation

enum TipoPreguntaEnum:String{
    case estrella = "Calificación (estrellas)"
    case segmento = "Opción múltiple (una opción)"
    case texto = "Texto breve"
    case fecha = "Fecha"
    case opcionMultiple = "Opción múltiple (varias opciones)"
    case comentarios = "Texto extenso"
    case email = "Correo electrónico"
    case celular = "Celular"
}

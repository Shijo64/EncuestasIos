//
//  EncuestaViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 10/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import ChameleonFramework
import Cosmos
import UITextView_Placeholder
import Reachability
import EmailValidator

class EncuestaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ResumenDelegate {

    var encuesta:EncuestaModel?
    var dataSet:PreguntaModel?
    var preguntas:[PreguntaModel] = []
    var currentIndex = 0
    var preguntasCount = 0
    var currentButtonSeleccionado:UIButton?
    var resumenPop = false
    var currentControl = ""
    var currentTextfield:UITextField?
    
    @IBOutlet weak var atrasButton: UIButton!
    @IBOutlet weak var siguienteButton: UIButton!
    @IBOutlet weak var preguntaLabel: UILabel!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var atrasButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var siguienteButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var numeroPreguntaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo-completo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.preguntaLabel.numberOfLines = 0
        self.preguntaLabel.sizeToFit()
        self.preguntaLabel.lineBreakMode = .byWordWrapping
        self.atrasButton.layer.cornerRadius = 15
        self.siguienteButton.layer.cornerRadius = 15

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        /*if(self.resumenPop){
            self.atrasButton.isHidden = false
            let mult:CGFloat = 0.48
            self.siguienteButtonWidthConstraint = self.siguienteButtonWidthConstraint.setMultiplier(multiplier: mult)
        }else{
            self.atrasButton.isHidden = true
            let mult:CGFloat = 1.0
            self.siguienteButtonWidthConstraint = self.siguienteButtonWidthConstraint.setMultiplier(multiplier: mult)
        }
        SharedData.sharedInstance.dismissProgressHud()
        self.getPreguntas()
        self.dataSet = self.preguntas[self.currentIndex]
        self.preguntaLabel.text = self.dataSet?.Description
        self.setPregunta()*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("Prueba")
        if(self.resumenPop){
            self.atrasButton.isHidden = false
            let mult:CGFloat = 0.48
            self.siguienteButtonWidthConstraint = self.siguienteButtonWidthConstraint.setMultiplier(multiplier: mult)
        }else{
            self.atrasButton.isHidden = true
            let mult:CGFloat = 1.0
            self.siguienteButtonWidthConstraint = self.siguienteButtonWidthConstraint.setMultiplier(multiplier: mult)
        }
        SharedData.sharedInstance.dismissProgressHud()
        self.getPreguntas()
        if(self.preguntas.count > 0){
            self.dataSet = self.preguntas[self.currentIndex]
            self.preguntaLabel.text = self.dataSet?.Description
            self.setPregunta()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.isMovingFromParent){
            SharedData.sharedInstance.respuestas = []
        }
    }
    
    func getPreguntas(){
        self.preguntas = []
        if(((self.encuesta?.Questions)?.count)! > 0){
            for pregunta in (self.encuesta?.Questions)!{
                self.preguntas.append(pregunta)
            }
            
            self.preguntas.sort {
                $0.Order < $1.Order
            }
        }else{
            self.siguienteButton.isHidden = true
            self.preguntaLabel.text = ""
            let alert = UIAlertController(title: "Aviso", message: "La encuesta no cuenta con preguntas, revisa la configuración en el portal", preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    @IBAction func siguientePregunta(_ sender: Any) {
        if(self.currentControl == "textfield"){
            if(self.currentTextfield?.layer.borderColor != UIColor.red.cgColor)
            {
                self.currentControl = ""
                self.siguientePregunta(UIButton())
            }
        }else{
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.atrasButton.isHidden = false
            let mult:CGFloat = 0.48
            self.siguienteButtonWidthConstraint = self.siguienteButtonWidthConstraint.setMultiplier(multiplier: mult)
            if(self.currentIndex < self.preguntas.count - 1){
                self.currentIndex = self.currentIndex + 1
                self.dataSet = self.preguntas[self.currentIndex]
                
                self.setPregunta()
                
                if(self.currentIndex == self.preguntas.count - 1){
                    self.siguienteButton.setTitle("Resumen", for: .normal)
                }
            }else{
                //Mostrar resumen
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "resumenController") as! ResumenTableViewController
                controller.encuesta = self.encuesta
                controller.delegate = self
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    @IBAction func preguntaAtras(_ sender: Any) {
        if(self.siguienteButton.isHidden){
            self.siguienteButton.isHidden = false
        }
        if(self.currentIndex > 0 && self.currentIndex <= (self.preguntas.count)){
            self.siguienteButton.setTitle("Siguiente", for: .normal)
            self.currentIndex = self.currentIndex - 1
            self.dataSet = self.preguntas[self.currentIndex]

            self.setPregunta()

            if(self.currentIndex == 0){
                self.navigationItem.setHidesBackButton(false, animated: true)
                self.atrasButton.isHidden = true
                let newMultiplier:CGFloat = 1.0
                self.siguienteButtonWidthConstraint = self.siguienteButtonWidthConstraint.setMultiplier(multiplier: newMultiplier)
            }
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func removePregunta(){
        let data = SharedData.sharedInstance.respuestas.filter{ $0.numeroPregunta != self.dataSet?.Order}
        SharedData.sharedInstance.respuestas = data
    }
    
    func setPopTrue() {
        self.resumenPop = true
    }

    func setPregunta(){
        let respuestasGuardadas = SharedData.sharedInstance.respuestas
        self.controlView.subviews.forEach({ $0.removeFromSuperview() })
        self.preguntaLabel.text = self.dataSet?.Description
        let numeroPregunta = self.currentIndex + 1
        self.numeroPreguntaLabel.text = "\(numeroPregunta) de \(self.preguntas.count)"
        var respuestaGuardada = EncuestaRespuestas()
        respuestaGuardada.numeroPregunta = (self.dataSet?.Order)!
        respuestaGuardada.idEncuesta = (self.dataSet?.SurveyId)!
        respuestaGuardada.idPregunta = (self.dataSet?.Id)!

        if let index = respuestasGuardadas.index(where: {$0.numeroPregunta == self.dataSet?.Order}){
            respuestaGuardada = respuestasGuardadas[index]
        }

        let opciones = self.getOpciones()
        
        
        switch self.dataSet?.QuestionType?.Description {
        case TipoPreguntaEnum.estrella.rawValue:
            self.currentControl = "estrella"
            let starView = CosmosView(frame: CGRect(x: 0, y: 0, width: self.controlView.frame.width * 0.8, height: self.controlView.frame.height * 0.5))
            starView.rating = 0
            starView.settings.fillMode = .full
            starView.settings.starSize = 65
            starView.settings.starMargin = 5
            starView.settings.filledColor = UIColor.flatYellow()
            starView.settings.emptyColor = UIColor.flatWhite()
            starView.settings.emptyBorderColor = UIColor.flatYellow()
            starView.settings.filledBorderColor = UIColor.flatWhite()
            starView.settings.emptyBorderWidth = 2.0
            starView.settings.filledBorderWidth = 2.0
            starView.didFinishTouchingCosmos = { rating in
                respuestaGuardada.respuesta = "\(rating)"
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }

            if let respuestaNumero = Double(respuestaGuardada.respuesta){
                let rating = respuestaNumero
                starView.rating = rating
            }else{
                respuestaGuardada.respuesta = "\(0)"
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }
            
            self.controlView.addSubview(starView)
        break
        case TipoPreguntaEnum.combo.rawValue:
            self.currentControl = "combo"
            let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.controlView.frame.width, height: self.controlView.frame.height * 0.5))
            picker.layer.cornerRadius = 15
            picker.delegate = self
            picker.dataSource = self
            picker.backgroundColor = UIColor.flatWhite()
            
            if (respuestaGuardada.respuesta != ""){
                let index = opciones.firstIndex(where: {$0.Id == Int(respuestaGuardada.respuesta)})
                picker.selectRow(index!, inComponent: 0, animated: true)
            }else{
                let dato = opciones.filter{$0.Default == true}.first
                respuestaGuardada.respuesta = "\((dato?.Id)!)"
                picker.selectRow((dato?.Order)! - 1, inComponent: 0, animated: true)
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }

            self.controlView.addSubview(picker)

        break
        case TipoPreguntaEnum.segmento.rawValue:
            self.currentControl = "segmento"
            var segmentoData:[String] = []
            for opcion in opciones{
                segmentoData.append(opcion.Description)
            }
            let segment = UISegmentedControl(items: segmentoData)
            segment.frame = CGRect(x: 0, y: 0, width: self.controlView.frame.width, height: self.controlView.frame.height * 0.20)
            segment.backgroundColor = UIColor.flatWhite()
            segment.tintColor = UIColor.flatSkyBlue()
            segment.addTarget(self, action: #selector(self.opcionSeleccionada(sender:)), for: .valueChanged)

            if  respuestaGuardada.respuesta != ""{
                let opcionGuardada = opciones.filter{$0.Id == Int(respuestaGuardada.respuesta)}.first
                segment.selectedSegmentIndex = (opcionGuardada?.Order)! - 1
            }else{
                let opcionGuardada = opciones.filter{$0.Default == true}.first
                segment.selectedSegmentIndex = (opcionGuardada?.Order)! - 1
                respuestaGuardada.respuesta = "\((opcionGuardada?.Id)!)"
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }
            
            self.controlView.addSubview(segment)
        break
        case TipoPreguntaEnum.texto.rawValue:
            self.currentControl = "textfield"
            let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: self.controlView.frame.width, height: self.controlView.frame.height * 0.15))
            textfield.layer.cornerRadius = 15
            textfield.backgroundColor = UIColor.flatWhite()
            textfield.borderStyle = .roundedRect
            textfield.returnKeyType = .done
            let font = UIFont(name: "Graphik-Light.ttf", size: 14)
            textfield.font = font
            textfield.delegate = self
            
            let respuesta = respuestaGuardada.respuesta
            if(respuesta != ""){
                textfield.text = respuestaGuardada.respuesta
            }else{
                textfield.placeholder = self.dataSet?.Description
                respuestaGuardada.respuesta = textfield.text!
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }
            self.currentTextfield = textfield
            self.controlView.addSubview(textfield)
        break
        case TipoPreguntaEnum.fecha.rawValue:
            self.currentControl = "fecha"
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.controlView.frame.width, height: self.controlView.frame.height * 0.5))
            datePicker.layer.cornerRadius = 15
            datePicker.backgroundColor = UIColor.flatWhite()
            datePicker.addTarget(self, action: #selector(self.fechaSeleccionada(sender:)), for: .valueChanged)
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"

            if let fecha = df.date(from: respuestaGuardada.respuesta){
                datePicker.date = fecha
            }else{
                datePicker.date = Date()
                respuestaGuardada.respuesta = df.string(from: Date())
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }

            self.controlView.addSubview(datePicker)
        break
        case TipoPreguntaEnum.opcionMultiple.rawValue:
            self.currentControl = "opcionMultiple"
            let opcionMultipleTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.controlView.frame.width, height: self.controlView.frame.height), style: .plain)
            opcionMultipleTableView.delegate = self
            opcionMultipleTableView.dataSource = self
            self.guardarRespuesta(respuesta: respuestaGuardada)
            
            opcionMultipleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "OpcionMultipleCell")
            self.controlView.addSubview(opcionMultipleTableView)
        break
        case TipoPreguntaEnum.comentarios.rawValue	:
            self.currentControl = "textview"
            let commentBox = UITextView(frame: CGRect(x: 0, y: 0, width: self.controlView.frame.width, height: self.controlView.frame.height))
            commentBox.layer.cornerRadius = 15
            let font = UIFont(name: "Graphik-Light.ttf", size: 14)
            commentBox.font = font
            commentBox.delegate = self

            if(respuestaGuardada.respuesta == ""){
                commentBox.placeholder = self.dataSet?.Description
                respuestaGuardada.respuesta = commentBox.text
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }else{
                commentBox.text = respuestaGuardada.respuesta
            }

            self.controlView.addSubview(commentBox)
        break
        case TipoPreguntaEnum.email.rawValue:
            self.currentControl = "textfield"
            let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: self.controlView.frame.width, height: self.controlView.frame.height * 0.15))
            textfield.layer.cornerRadius = 15
            textfield.backgroundColor = UIColor.flatWhite()
            textfield.borderStyle = .roundedRect
            textfield.returnKeyType = .done
            textfield.keyboardType = .emailAddress
            textfield.autocapitalizationType = .none
            let font = UIFont(name: "Graphik-Light.ttf", size: 14)
            textfield.font = font
            textfield.delegate = self
            
            let respuesta = respuestaGuardada.respuesta
            if(respuesta != ""){
                textfield.text = respuestaGuardada.respuesta
            }else{
                textfield.placeholder = self.dataSet?.Description
                respuestaGuardada.respuesta = textfield.text!
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }
            self.currentTextfield = textfield
            self.controlView.addSubview(textfield)
        break
        case TipoPreguntaEnum.celular.rawValue:
            self.currentControl = "textfield"
            let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: self.controlView.frame.width, height: self.controlView.frame.height * 0.15))
            textfield.layer.cornerRadius = 15
            textfield.backgroundColor = UIColor.flatWhite()
            textfield.borderStyle = .roundedRect
            textfield.returnKeyType = .done
            textfield.keyboardType = .phonePad
            let font = UIFont(name: "Graphik-Light.ttf", size: 14)
            textfield.font = font
            textfield.delegate = self
            
            let respuesta = respuestaGuardada.respuesta
            if(respuesta != ""){
                textfield.text = respuestaGuardada.respuesta
            }else{
                textfield.placeholder = self.dataSet?.Description
                respuestaGuardada.respuesta = textfield.text!
                self.guardarRespuesta(respuesta: respuestaGuardada)
            }
            self.currentTextfield = textfield
            self.controlView.addSubview(textfield)
        break
        default:
            break
        }
    }

    func guardarRespuesta(respuesta:EncuestaRespuestas){
        let data = SharedData.sharedInstance.respuestas
        let count = data.count
        if(count > 0){
            if let index = data.index(where: {$0.numeroPregunta == respuesta.numeroPregunta}){
                SharedData.sharedInstance.respuestas[index] = respuesta
            }else{
                SharedData.sharedInstance.respuestas.append(respuesta)
            }
        }else{
            SharedData.sharedInstance.respuestas.append(respuesta)
        }
    }
    
    //MARK: Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let opciones = self.getOpciones()
        return opciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpcionMultipleCell")
        cell?.selectionStyle = .none
        let opciones = self.getOpciones()
        let opcion = opciones[indexPath.row]
        let respuestas = SharedData.sharedInstance.respuestas.filter{$0.numeroPregunta == self.dataSet?.Order}
        if(respuestas.count > 0){
            let respuesta = respuestas.first
            if((respuesta?.arrayRespuestas.contains("\(opcion.Id)"))!){
                cell?.accessoryType = .checkmark
            }else{
                cell?.accessoryType = .none
            }
        }
        
        cell!.textLabel?.text = opcion.Description
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var answer:EncuestaRespuestas?
        let opciones = self.getOpciones()
        let opcion = opciones[indexPath.row]
        let respuestas = SharedData.sharedInstance.respuestas.filter{$0.numeroPregunta == self.dataSet?.Order}
        if let respuesta = respuestas.first{
            answer = respuesta
        }else{
            answer = EncuestaRespuestas()
            answer!.numeroPregunta = (self.dataSet?.Order)!
            answer!.idEncuesta = (self.dataSet?.SurveyId)!
            answer!.idPregunta = (self.dataSet?.Id)!
        }
        let cell = tableView.cellForRow(at: indexPath)
        let busqueda = answer?.arrayRespuestas.filter{$0 == "\(opcion.Id)"}
        if(busqueda!.count > 0){
            cell?.accessoryType = .none
            let index = answer?.arrayRespuestas.firstIndex(of: "\(opcion.Id)")
            answer?.arrayRespuestas.remove(at: index!)
            answer?.respuesta = (answer?.arrayRespuestas.joined(separator: ","))!
            self.guardarRespuesta(respuesta: answer!)
            //let indexAnswer = SharedData.sharedInstance.respuestas.firstIndex{$0.numeroPregunta == answer?.numeroPregunta}
            //SharedData.sharedInstance.respuestas[indexAnswer!] = answer!
        }else{
            cell?.accessoryType = .checkmark
            let opcionSeleccionada = opciones[indexPath.row]
            answer!.idEncuesta = (self.dataSet?.SurveyId)!
            answer!.numeroPregunta = (self.dataSet?.Order)!
            answer!.idPregunta = (self.dataSet?.Id)!
            answer?.arrayRespuestas.append("\(opcionSeleccionada.Id)")
            answer?.respuesta = (answer?.arrayRespuestas.joined(separator: ","))!
            self.guardarRespuesta(respuesta: answer!)
        }
    }

    //MARK: Buttons
    @objc func botonSeleccionado(sender: UIButton){
        if(self.currentButtonSeleccionado != nil){
            self.currentButtonSeleccionado?.backgroundColor = UIColor.flatWhite()
        }
        
        let respuesta = sender.titleLabel?.text
        let dato = EncuestaRespuestas()
        dato.numeroPregunta = (self.dataSet?.Order)!
        dato.idEncuesta = (self.dataSet?.SurveyId)!
        dato.idPregunta = (self.dataSet?.Id)!
        dato.respuesta = respuesta!
        self.guardarRespuesta(respuesta: dato)
        
        let buttonColor = sender.backgroundColor
        if(buttonColor! == UIColor.flatWhite()){
            sender.backgroundColor = UIColor.flatSkyBlue()
            self.currentButtonSeleccionado = sender
        }else{
            sender.backgroundColor = UIColor.flatWhite()
        }
    }

    //MARK: DatePicker
    @objc func fechaSeleccionada(sender: UIDatePicker){
        let fecha = sender.date
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let respuesta = df.string(from: fecha)
        let dato = EncuestaRespuestas()
        dato.numeroPregunta = (self.dataSet?.Order)!
        dato.idEncuesta = (self.dataSet?.SurveyId)!
        dato.idPregunta = (self.dataSet?.Id)!
        dato.respuesta = respuesta
        self.guardarRespuesta(respuesta: dato)
    }

    //MARK: Segment
    @objc func opcionSeleccionada(sender: UISegmentedControl){
        let opciones = self.getOpciones()
        let respuesta = opciones[sender.selectedSegmentIndex].Id
        let dato = EncuestaRespuestas()
        dato.numeroPregunta = (self.dataSet?.Order)!
        dato.idEncuesta = (self.dataSet?.SurveyId)!
        dato.idPregunta = (self.dataSet?.Id)!
        dato.respuesta = "\(respuesta)"
        self.guardarRespuesta(respuesta: dato)
    }

    //MARK: Textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.keyboardType == .phonePad){
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if(textField.keyboardType == .emailAddress){
            let validEmail = self.validate(field: textField)
            if(validEmail!){
                self.removeErrorHighlightTextField(textField: textField)
            }else{
                self.errorHighlightTextField(textField: textField)
            }
            return true
        }else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let respuesta = textField.text
        let dato = EncuestaRespuestas()
        dato.numeroPregunta = (self.dataSet?.Order)!
        dato.idEncuesta = (self.dataSet?.SurveyId)!
        dato.idPregunta = (self.dataSet?.Id)!
        dato.respuesta = respuesta!
        self.guardarRespuesta(respuesta: dato)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let respuesta = textField.text
        let dato = EncuestaRespuestas()
        dato.numeroPregunta = (self.dataSet?.Order)!
        dato.idEncuesta = (self.dataSet?.SurveyId)!
        dato.idPregunta = (self.dataSet?.Id)!
        dato.respuesta = respuesta!
        self.guardarRespuesta(respuesta: dato)
        textField.resignFirstResponder()
        return true
    }
    
    // Text Field is empty - show red border
    func errorHighlightTextField(textField: UITextField){
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }
    
    // Text Field is NOT empty - show gray border with 0 border width
    func removeErrorHighlightTextField(textField: UITextField){
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5
    }

    //MARK: PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.dataSet?.AnswerOptions.count)!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var opciones:[OpcionesPreguntaModel] = []
        for AnswerOption in (self.dataSet?.AnswerOptions)!{
            opciones.append(AnswerOption)
        }
        let opcion = opciones[row]
        return opcion.Description
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var opciones:[OpcionesPreguntaModel] = []
        for AnswerOption in (self.dataSet?.AnswerOptions)!{
            opciones.append(AnswerOption)
        }
        let respuesta = opciones[row]
        let dato = EncuestaRespuestas()
        dato.numeroPregunta = (self.dataSet?.Order)!
        dato.idEncuesta = (self.dataSet?.SurveyId)!
        dato.idPregunta = (self.dataSet?.Id)!
        dato.respuesta = "\(respuesta.Id)"
        self.guardarRespuesta(respuesta: dato)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label:UILabel
        
        if let v = view as? UILabel{
            label = v
        }
        else{
            label = UILabel()
        }
        
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "Graphik-Light.ttf", size: 16)
        
        var opciones:[OpcionesPreguntaModel] = []
        for AnswerOption in (self.dataSet?.AnswerOptions)!{
            opciones.append(AnswerOption)
        }
        let opcion = opciones[row]
        label.text = opcion.Description
        
        return label
    }

    //MARK: TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.flatBlackColorDark()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let respuesta = textView.text
        let dato = EncuestaRespuestas()
        dato.numeroPregunta = (self.dataSet?.Order)!
        dato.idEncuesta = (self.dataSet?.SurveyId)!
        dato.idPregunta = (self.dataSet?.Id)!
        dato.respuesta = respuesta!
        self.guardarRespuesta(respuesta: dato)
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func getOpciones() -> [OpcionesPreguntaModel]{
        var opciones:[OpcionesPreguntaModel] = []
        for opcion in (self.dataSet?.AnswerOptions)!{
            opciones.append(opcion)
        }
        
        return opciones
    }
    
    func validate(field: UITextField) -> Bool? {
        guard let trimmedText = field.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }
        
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)
        
        if allMatches.count == 1,
            allMatches.first?.url?.absoluteString.contains("mailto:") == true
        {
            return true
        }
        return false
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

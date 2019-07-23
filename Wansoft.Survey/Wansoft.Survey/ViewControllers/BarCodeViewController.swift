//
//  BarCodeViewController.swift
//  EncuestaSatisfaccion
//
//  Ceated by Jaime Leija Morales on 05/02/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import MTBBarcodeScanner
import CameraBackground

class BarCodeViewController: UIViewController {

    var barCodeScanner:MTBBarcodeScanner?
    weak var delegate:BarcodeDelegate?
    let anotherButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    @IBOutlet weak var codigoLabel: UILabel!
    @IBOutlet weak var aceptarButton: UIButton!
    @IBOutlet weak var barcodeView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.aceptarButton.layer.cornerRadius = 15
        //self.aceptarButton.isHidden = true
        self.cameraView.layer.cornerRadius = 5
        self.anotherButton.setImage(UIImage(named: "photoAnother"), for: .normal)
        self.anotherButton.backgroundColor = UIColor.white
        self.anotherButton.layer.cornerRadius = self.anotherButton.frame.width/2
        self.anotherButton.addTarget(self, action: #selector(self.restartScan), for: .touchUpInside)
        self.anotherButton.isHidden = true
        self.backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "restaurant-desk")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scanCode()
        self.makeTransparentRectangle(view: self.backgroundView, childView:self.cameraView)
        //self.makeTransparentRectangle(view: self.backImageView, childView: self.cameraView)
    }
    
    @objc func scanCode(){
        let preView = UIView(frame: self.barcodeView.bounds)
        self.barcodeView.addSubview(preView)
        self.barCodeScanner = MTBBarcodeScanner(previewView: preView)
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.barCodeScanner?.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            for code in codes {
                                let stringValue = code.stringValue!
                                //self.barCodeScanner?.stopScanning()
                                self.barCodeScanner?.freezeCapture()
                                //self.codigoLabel.text = stringValue
                                self.anotherButton.center = preView.center
                                self.anotherButton.isHidden = false
                                let alert = UIAlertController(title: "Exito", message: "el codigo escaneado es: \(stringValue)", preferredStyle: .alert)
                                let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: {(action) in
                                    self.aceptarCodigo(codigo:stringValue)
                                })
                                
                                let reintentar = UIAlertAction(title: "Escanear de nuevo", style: .default, handler: {(action) in
                                    self.restartScan()
                                })
                                
                                alert.addAction(reintentar)
                                alert.addAction(aceptar)
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    })
                } catch {
                    NSLog("Unable to start scanning")
                }
            } else {
                let alert = UIAlertController(title: "Aviso", message: "Esta aplicación requiere permisos de camara", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @objc func restartScan(){
        //self.codigoLabel.text = ""
        self.anotherButton.isHidden = true
        //self.aceptarButton.isHidden = true
        
        self.barCodeScanner?.unfreezeCapture()
    }
    
    func aceptarCodigo(codigo:String){
        delegate?.sendCodigo(codigo: codigo)
        self.navigationController?.popViewController(animated: true)
    }
    /*@IBAction func aceptarCodigo(_ sender: Any) {
        //let codigo = self.codigoLabel.text
        //delegate?.sendCodigo(codigo: codigo!)
        self.navigationController?.popViewController(animated: true)
    }*/
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func makeTransparentRectangle(view:UIView, childView:UIView){
        let rect = CGRect(x: childView.frame.origin.x + 5, y: childView.frame.origin.y + 5, width: childView.frame.width - 10, height: childView.frame.height - 10)
        let finalPath = UIBezierPath(rect: view.bounds)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        finalPath.append(UIBezierPath(rect: rect))
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.path = finalPath.cgPath
        view.layer.mask = maskLayer
    }

}

protocol BarcodeDelegate:class{
    func sendCodigo(codigo:String)
}

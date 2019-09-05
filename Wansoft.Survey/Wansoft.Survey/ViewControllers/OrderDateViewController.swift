//
//  OrderDateViewController.swift
//  EncuestaSatisfaccion
//
//  Created by Jaime Leija Morales on 13/06/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import UIKit
import CVCalendar
import MaterialComponents

class OrderDateViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var salirButton: MDCButton!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var delegate:FechaDelegate?
    var currentDate = Date()
    private var animationFinished = true
    private var currentCalendar: Calendar?
    var selectedDay:CVCalendarDayView?
    
    
    
    override func awakeFromNib() {
        self.currentCalendar = Calendar(identifier: .gregorian)
        self.currentCalendar?.locale = Locale(identifier: "es_MX")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.toggleViewWithDate(self.currentDate)
        self.calendarView.didSelectDayView(self.selectedDay!)
        if let currentCalendar = currentCalendar {
            self.monthLabel.text = CVDate(date: self.currentDate, calendar: currentCalendar).globalDescription
        }
        /*self.dateView.layer.cornerRadius = 10
        self.dateView.layer.masksToBounds = true
        self.salirButton.layer.cornerRadius = 10
        self.salirButton.layer.masksToBounds = true
        self.datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        self.datePicker.date = self.currentDate*/
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker){
        /*let fecha = sender.date
        delegate?.seleccionarFecha(fecha: fecha)
        self.dismiss(animated: true, completion: nil)*/
    }
    
    @IBAction func salir(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func aceptarFecha(_ sender: Any) {
        let date = self.selectedDay?.date.convertedDate()
        delegate?.seleccionarFecha(fecha: date!)
        self.dismiss(animated: true, completion: nil)
    }
    
    //CalendarViewDelegate
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func calendar() -> Calendar? {
        return self.currentCalendar
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return .white
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    
    // Defaults to true
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        self.selectedDay = dayView
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool
    {
        return true
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType
    {
        return .short
    }
    
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor(hexString: "#3E4883")
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }

    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    /*func presentedDateUpdated(_ date: CVDate) {
        if self.monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }*/
}

protocol FechaDelegate: class{
    func seleccionarFecha(fecha: Date)
}

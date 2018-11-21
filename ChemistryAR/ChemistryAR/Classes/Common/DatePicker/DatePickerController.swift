//
//  DatePickerController.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /// Add a date picker
    ///
    /// - Parameters:
    ///   - mode: date picker mode
    ///   - date: selected date of date picker
    ///   - minimumDate: minimum date of date picker
    ///   - maximumDate: maximum date of date picker
    ///   - action: an action for datePicker value change
    
    func addDatePicker(mode: UIDatePicker.Mode, date: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: DatePickerViewController.Action?) {
        let datePicker = DatePickerViewController(mode: mode,
                                                  date: date,
                                                  useChangeValue:true,
                                                  minimumDate: minimumDate,
                                                  maximumDate: maximumDate,
                                                  action: action)
        set(vc: datePicker, height: 217)
    }
    
    class func showDatePicker(style: UIAlertController.Style,
                              mode:UIDatePicker.Mode,
                              useChangeValue:Bool = false,
                              title:String,
                              currentDate:Date?,
                              minimumDate: Date? = nil,
                              maximumDate: Date? = nil,
                              action: DatePickerViewController.Action?)  {
        let alert = UIAlertController(style: style, title:title)
        let datePicker = DatePickerViewController(mode: mode,
                                                  date: currentDate,
                                                  useChangeValue: useChangeValue,
                                                  minimumDate: minimumDate,
                                                  maximumDate: maximumDate,
                                                  action: action)
        alert.set(vc: datePicker, height: 217)
        
        alert.addAction(title: "OK",
                        color: AppColor.mainColor,
                        style: .cancel,
                        isEnabled: true) { (action) in
                            print("Date selected:\(datePicker.datePicker.date)")
                            datePicker.action?(datePicker.datePicker.date)
        }
        alert.show()
    }
}

final class DatePickerViewController: UIViewController {
    
    public typealias Action = (Date) -> Void
    
    fileprivate var action: Action?
    
    fileprivate var useChangeValue: Bool = false
    
    
    fileprivate lazy var datePicker: UIDatePicker = { [unowned self] in
        if useChangeValue{
            $0.addTarget(self, action: #selector(DatePickerViewController.actionForDatePicker), for: .valueChanged)
        }
        return $0
        }(UIDatePicker())
    
    required init(mode: UIDatePicker.Mode,
                  date: Date? = nil,
                  useChangeValue:Bool,
                  minimumDate: Date? = nil,
                  maximumDate: Date? = nil,
                  action: Action?) {
        super.init(nibName: nil, bundle: nil)
        self.useChangeValue = useChangeValue
        datePicker.datePickerMode = mode
        datePicker.date = date ?? Date()
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //Log("has deinitialized")
    }
    
    override func loadView() {
        view = datePicker
    }
    
    @objc func actionForDatePicker() {
        action?(datePicker.date)
    }
    
    public func setDate(_ date: Date) {
        datePicker.setDate(date, animated: true)
    }
}

//
//  TimeSlotsViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 25/10/21.
//

import UIKit
import SmoothPicker

class TimeSlotsViewController: BaseViewController {

    @IBOutlet weak var dayPickerView: SmoothPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIPickerView!{
        didSet {
            timePicker.dataSource = self
            timePicker.delegate = self
        }
    }

    
    var slotDate = Date()

    lazy var monthDateDayInfo: ([String], [String], [String]) = {
        let arr = getMonthDate(date: slotDate)
        return arr
    }()

    let pickerView = UIPickerView()
    var rotationAngle: CGFloat!
    let width: CGFloat = 60.0
    let height: CGFloat = 60.0
    
    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    let formatter = "yyyy-MM-dd"

    var hours   : [String] = []
    var splits  : [String] = []
    var minutes : [String] = []
    var selectedTime: String = ""
    var h: String = "00"
    var m: String = "00"
    
    var bookedSlotInfo = [BookedSlot]()
    
    var meridiem: Meridiem = .Am
    
    var selectedDate: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        SmoothPickerConfiguration.setSelectionStyle(selectionStyle: .colored)
        let currentDate = slotDate.asString(withFormat: "dd")
        dayPickerView.firstselectedItem = monthDateDayInfo.0.firstIndex(where: {$0 == currentDate}) ?? 2
        dayPickerView.reloadData()

        for i in 0...12 {
            hours.append(String(format: "%02d", i))
        }

        for _ in 0...12 {
            splits.append(":")
        }

        for i in 0...59 {
            minutes.append(String(format: "%02d", i))
        }
        
        viewModel.delegate = self
        
        if let storeId = AppointmentManager.shared.store?.id {
            viewModel.getBookedSlotList(date: slotDate.asString(withFormat: formatter), storeId: "\(storeId)")
        }
        
        datePicker.tintColor = .cwSecondary
//        datePicker.minimumDate = currentDate

        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
    }
     
    func getMonthDate(date: Date) -> ([String], [String], [String]) {
        
        var _date = [String]()
        var _day = [String]()
        var _dateString = [String]()
        let allDays = date.getAllDays()
        
        for day in allDays {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"
            _date.append("\(day.asString(withFormat: "dd"))")
            _dateString.append("\(day.asString(withFormat: formatter))")
            _day.append(dateFormatter.string(from: day))
        }
        _date.removeLast()
        _day.removeLast()
        _dateString.removeLast()
        return (_date, _day, _dateString)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        meridiem = segmentedControl.selectedSegmentIndex == 0 ? .Am : .Pm
    }

    @IBAction func nextBtn(_ sender: UIButton) {
        
        guard bookedSlotInfo.count > 0 else {
            self.displayError(withMessage: .noTimeSlotAvailable)
            return
        }
        
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.SummaryVC) as! SummaryViewController
        vc.appointmentDate = selectedDate + "T" + selectedTime
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dueDateChanged(sender: UIDatePicker){
        slotDate = sender.date
        monthDateDayInfo = getMonthDate(date: slotDate)
        dayPickerView.firstselectedItem = 2
        presentedViewController?.dismiss(animated: true, completion: nil)
        dayPickerView.reloadData()
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TimeSlotsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return hours.count
        case 1: return 1
        case 2: return minutes.count
        default: break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return height
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
            pickerLabel?.textAlignment = .center
        }
        
        switch component {
        case 0: pickerLabel?.text = hours[row]
        case 1: pickerLabel?.text = ":"
        case 2: pickerLabel?.text = minutes[row]
        default: break
        }
       
        pickerLabel?.textColor = UIColor.white
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:  h = hours[row]
        case 2:  m = minutes[row]
        default: break
        }
        
        selectedTime = h + ":" + m + ":00Z"
        
    }
    
}

extension TimeSlotsViewController: AppointmentDelegate {
    
    func getBookedSlotInfo(_bookedSlotInfo: SlotInfo) {
        MBProgressHUD.hide(for: UIApplication.shared.windows.first!, animated: true)
        
        if let bookedSlots = _bookedSlotInfo.bookedSlots {
            bookedSlotInfo = bookedSlots
            
            guard bookedSlotInfo.count > 0 else {
                self.displayError(withMessage: .noTimeSlotAvailable)
                return
            }
        }
    }

    func failure(message: String) {
        
    }

    func getStoreList(_storeListData: [Store]) {
        
    }
    
    func getServiceList(_serviceList: [Service]) {
        
    }
    
    func getCouponListInfo(_couponList: [Coupon]) {
        
    }

    func appointmentList(_appointmentList: [BookedAppointment]) {
        
    }

    func successful(message: String) {

    }

    func bookAppointment(_appointmentInfo: BookAppointmentModel) {
        
    }
    
    func ratingList(_ratingList: [Rating]) {
        
    }

}

extension TimeSlotsViewController: SmoothPickerViewDelegate,SmoothPickerViewDataSource {
    
    func numberOfItems(pickerView: SmoothPickerView) -> Int {
        return monthDateDayInfo.0.count
    }
    
    func itemForIndex(index: Int, pickerView: SmoothPickerView) -> UIView {
        let dayVw = DayItemView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        
        let date = monthDateDayInfo.0
        let day  = monthDateDayInfo.1

        dayVw.setData(date: date[index], day: day[index])
        return dayVw
        
    }

    func didSelectItem(index: Int, view: UIView, pickerView: SmoothPickerView) {
        print("Selected \(monthDateDayInfo.0[index])")
        
        let date = monthDateDayInfo.2[index]
        
        selectedDate = date
        if let storeId = AppointmentManager.shared.store?.id {
            viewModel.getBookedSlotList(date: date, storeId: "\(storeId)")
        }
        
//        pickerView.navigate(direction: .next)
        
    }
}

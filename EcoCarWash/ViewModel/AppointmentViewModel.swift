//
//  AppointmentViewModel.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 29/11/21.
//

import Foundation


protocol AppointmentDelegate {
    func getStoreList(_storeListData: [Store])
    func getServiceList(_serviceList: [Service])
    func getBookedSlotInfo(_bookedSlotInfo: SlotInfo)
    func getCouponListInfo(_couponList: [Coupon])
    func bookAppointment(_appointmentInfo: BookAppointmentModel)
    func appointmentList(_appointmentList: [BookedAppointment])
    func ratingList(_ratingList: [Rating])
    func successful(message: String)
    func failure(message: String)
}

// MARK: - With Coupon
struct BookAppointmentRequest: Codable {
    let services : [Int]
    let date : String
    let total_time : Int
    let appointment_nature: String
    let appointment_type: String
    let payment_type: String
    let payment_status: String
    let amount_paid : Double
    let store: Int
    let user_address:Int
    let user_car: Int
    let address: String
    let latitude: Double
    let longitude: Double
    let applied_coupon: Int
}

// MARK: - Without Coupon
struct AppointmentRequest: Codable {
    let services : [Int]
    let date : String
    let total_time : Int
    let appointment_nature: String
    let appointment_type: String
    let payment_type: String
    let payment_status: String
    let amount_paid : Double
    let store: Int
    let user_address:Int
    let user_car: Int
    let address: String
    let latitude: Double
    let longitude: Double
    let applied_coupon: Int
}

struct RatingRequest: Codable {
    let rating: Int
    let review: String
    let is_approved: Bool
    let appointment: Int
}

class AppointmentViewModel {
    
    var delegate: AppointmentDelegate!
    
    func getStoreListFrom(distance: String, lat: String, long: String) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.listStores(distance: distance, latitude: lat, longitude: long), completion: { (result : Result<StoreListModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.getStoreList(_storeListData: data.data ?? [])
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func getServiceListFrom(carType: Int, storeId: Int) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.listService(carType: carType, storeId: storeId), completion: { (result : Result<ServiceListModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.getServiceList(_serviceList: data.data ?? [])
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }

    func getBookedSlotList(date: String, storeId: String) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.bookedSlotList(date: date, storeId: storeId), completion: { (result : Result<BookedSlotListModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  :
                    
                    if let data = data.data {
                        self.delegate.getBookedSlotInfo(_bookedSlotInfo: data)
                    }

                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }

    func getCoupon() {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.listCoupons, completion: { (result : Result<CouponDTO, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.getCouponListInfo(_couponList: data.data ?? [])

                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }

    func bookAppointment(info: BookAppointmentRequest) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.bookAppointment(_info: info), completion: { (result : Result<BookAppointmentModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.bookAppointment(_appointmentInfo: data)
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func getAppointmentList(status: String = "all") {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.ListAppointment(status: status), completion: { (result : Result<GetAppointmentDTO, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.appointmentList(_appointmentList: data.data ?? [])

                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }

    func deleteAppointmentList(id: String) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.deleteAppointment(appointmentId: id), completion: { (result : Result<CommonDTO, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.successful(message: data.message ?? "")

                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func getAppointment(by id: String) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.getAppointment(appointmentId: id), completion: { (result : Result<GetAppointmentDTO, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.appointmentList(_appointmentList: data.data ?? [])

                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func postAppointmentRating(info: RatingRequest) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.appointmentRating(_info: info), completion: { (result : Result<PostRatingModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.successful(message: data.message ?? "")
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func getReviewList(by isRating: Bool) {
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.getRatingList(isRating: isRating), completion: { (result : Result<ReviewModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  :
                    
                    if let ratingList = data.data?.results {
                        self.delegate.ratingList(_ratingList: ratingList)
                    }
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
}

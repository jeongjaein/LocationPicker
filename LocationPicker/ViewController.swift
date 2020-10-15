//
//  ViewController.swift
//  LocationPicker
//
//  Created by 정재인 on 2020/10/12.
//

import UIKit
import NMapsMap
import Then
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    var mapView = NMFMapView()
    let cameraPosition = NMFCameraPosition()
    let pin = UIImageView()
    var task: DispatchWorkItem?
    var addressLabel = UILabel()
    var searchTextField = UITextField()
    let headers: HTTPHeaders = [ "Authorization": "KakaoAK 6cd40b04c090b1a033634e5051aab78c" ]
    let decoder = JSONDecoder()
    var totalList: [NMGLatLng] = []
    var cameraUpdate = NMFCameraUpdate()
    var newLng: Double = 0
    var newLat: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        searchTextField.delegate = self
    }
    
    func attribute() {
        mapView = NMFMapView(frame: view.frame)
        mapView.addCameraDelegate(delegate: self)
        
        pin.do {
            $0.image = #imageLiteral(resourceName: "marker")
        }
        addressLabel.do {
            $0.backgroundColor = .black
            $0.alpha = 10
            $0.text = "좌표가 찍힐 거에요"
            $0.textColor = .white
            $0.textAlignment = .center
        }
        searchTextField.do {
            $0.backgroundColor = .black
            $0.textColor = .white
            $0.textAlignment = .center
            $0.placeholder = "역 이름을 검색하세요 ~~"
            $0.borderStyle = .line
        }
    }
    
    
    func layout() {
        view.addSubview(mapView)
        view.addSubview(pin)
        view.addSubview(addressLabel)
        view.addSubview(searchTextField)
        
        pin.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 35).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        addressLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        searchTextField.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: addressLabel.bottomAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }

    func search(keyword: String) -> String {
        let parameters: [String: String] = [
            "query": keyword
        ]
        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json",
                   method: .get,
                   parameters: parameters,
                   headers: headers).responseJSON(completionHandler: { [self] responds in
                    switch responds.result {
                    case .success(let value):
                        if let addressList = JSON(value)["documents"].array {
                            for item in addressList {
                                newLng = Double(item["x"].string ?? "")!
                                newLat = Double(item["y"].string ?? "")!
                                var test: NMFCameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: newLat, lng: newLng))
                                test.animation = .easeOut
                                mapView.moveCamera(test)
                                break
                            }
                        }
                    case .failure(let err) :
                        print(err)
                    }
                   })
        
        return keyword
    }
}
extension ViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        task = DispatchWorkItem { [self] in
            self.pin.alpha = 1
            addressLabel.text = "\(mapView.cameraPosition.target.lat),   \(mapView.cameraPosition.target.lng)"
            print(newLat,newLng)
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.pin.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task!)
    }
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        self.view.endEditing(true)
        task?.cancel()
        pin.alpha = 0.5
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.pin.transform = CGAffineTransform(translationX: 0, y: -10)
        })
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }else {
            search(keyword: textField.text ?? "")
            return true
        }
    }
}




//                                let addressName = item["address_name"].string ?? ""
//                                let jibunAddress = item["address_name"].string ?? "없음"
//                                let roadAddress = item["road_address"].string ?? "없음"
//                                let depthOneName = item["address"]["region_1depth_name"].string ?? ""
//                                let depthTwoName = item["address"]["region_2depth_name"].string ?? ""
//                                let lng = item["address"]["x"].string ?? ""
//                                let lat = item["address"]["y"].double ?? 0
//                                let depthThreeName = item["address"]["region_3depth_name"].string ?? ""
//                                let postCode = (item["address"]["zip_code"].string ?? "").isEmpty ? "우편번호 없음" : item["address"]["zip_code"].string ?? ""
//                                totalList.append(Address(addressName: addressName,
//                                                         postCode: postCode,
//                                                         roadAddr: roadAddress,
//                                                         jibunAddr: jibunAddress,
//                                                         depthOneAddr: depthOneName,
//                                                         deptTwoAddr: depthTwoName,
//                                                         deptThreeAddr: depthThreeName,
//                                                         lng: Double(lng)!,
//                                                         lat: lat)
//                                )

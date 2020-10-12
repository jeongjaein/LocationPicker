//
//  ViewController.swift
//  LocationPicker
//
//  Created by 정재인 on 2020/10/12.
//

import UIKit
import NMapsMap
import Then

class ViewController: UIViewController {
    var mapView = NMFMapView()
    let pin = UIImageView()
    var task: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    func attribute() {
        mapView = NMFMapView(frame: view.frame)
        mapView.addCameraDelegate(delegate: self)
        pin.do {
            $0.image = #imageLiteral(resourceName: "marker")
        }
    }
    
    func layout() {
        view.addSubview(mapView)
        view.addSubview(pin)
        
        pin.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -28).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 35).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
}

extension ViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
            task = DispatchWorkItem {
                self.pin.alpha = 1
                //카메라포지션을 저장해줌(보기에편하게)
                _ = self.mapView.cameraPosition
                
                let lng = Double(self.mapView.cameraPosition.target.lng)
                let lat = Double(self.mapView.cameraPosition.target.lat)
                
//                self.viewModel.inputs.longitude.onNext(lng)
//                self.viewModel.inputs.latitude.onNext(lat)
                
//                self.viewModel.outputs.address
//                    .subscribe(onNext: { value in
//                        self.addressLable.text = String(value.address)
//                        self.roadAddressLable.text = String(value.roadAddress)
//                        self.lat = Double(value.lat)
//                        self.lng = Double(value.lng)
//                    })
//                    .disposed(by: self.disposeBag)
                
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.pin.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task!)
    }
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        task?.cancel()
        pin.alpha = 0.5
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.pin.transform = CGAffineTransform(translationX: 0, y: -10)
        })
    }
}


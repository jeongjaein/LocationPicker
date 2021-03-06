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
    let cameraPosition = NMFCameraPosition()
    
    let pin = UIImageView()
    var task: DispatchWorkItem?
    var addressLabel = UILabel()
    var searchTextField = UITextField()
    
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
}

extension ViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        task = DispatchWorkItem { [self] in
            self.pin.alpha = 1
            addressLabel.text = "\(mapView.cameraPosition.target.lat),   \(mapView.cameraPosition.target.lng)"
            
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


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
    let pinImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    func attribute() {
        mapView = NMFMapView(frame: view.frame)
    }
    
    func layout() {
        view.addSubview(mapView)
    }
}


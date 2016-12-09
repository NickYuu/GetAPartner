//
//  MapViewController.swift
//  GetAPartner
//
//  Created by 游宗翰 on 2016/9/22.
//  Copyright © 2016年 han. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK:- 屬性
    var position = ""
    let locationManager = CLLocationManager()
    var typeCount = 0
    var animalCoordinate:CLLocationCoordinate2D!
    
    // MARK:- 元件屬性
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeBtn: UIButton!
    @IBOutlet weak var userLocationBtn: UIButton!
    @IBOutlet weak var animalLocationBtn: UIButton!
    @IBOutlet weak var mapTypeBtn: UIButton!
    
    // MARK:- 系統調用函式
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocationClick()
        animalLocationClick()
        
    }
    
    // MARK:- 按鈕點擊事件
    @IBAction func route(_ sender: UIButton) {
        routeClick()
    }
    
    @IBAction func userLocation(_ sender: UIButton) {
        userLocationClick()
    }
    
    
    @IBAction func animalLocation(_ sender: UIButton) {
        animalLocationClick()
    }
    
    
    @IBAction func changeType(_ sender: UIButton) {
        changTypeClick()
    }
    
    
}

// MARK:- 事件監聽
extension MapViewController {
    
    fileprivate func routeClick() {
        if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController,animated: true, completion: nil)
            return
        }
        let coordinate = locationManager.location?.coordinate
        if animalCoordinate != nil && coordinate != nil{
            let myMark = MKPlacemark(coordinate: coordinate!, addressDictionary: nil)
            let animalMark = MKPlacemark(coordinate: animalCoordinate, addressDictionary: nil)
            
            let me = MKMapItem(placemark: myMark)
            let animal = MKMapItem(placemark: animalMark)
            
            me.name = "目前位置"
            animal.name = position
            
            MKMapItem.openMaps(with: [me, animal], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
            
        }
    }
    
    
    fileprivate func userLocationClick() {
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            locationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController,animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // 開始定位自身位置
            let coordinate = locationManager.location?.coordinate
            
            if coordinate != nil{
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate!
                annotation.title = "目前位置"
                mapView.addAnnotation(annotation)
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    
    fileprivate func animalLocationClick(){
        
        
        if position.contains("動物之家"){
            getMap(geocoderAdd: "臺北市信義區吳興街600巷109號", title: "臺北市動物之家")
            //臺北市信義區吳興街600 巷109 號
        }else if position.contains("防止虐待動物協會"){
            getMap(geocoderAdd: "新北市永和區保福路二段16巷27號", title: "台灣防止虐待動物協會")
            //新北市永和區保福路二段16巷27號
        }else if position.contains("流浪貓"){
            getMap(geocoderAdd: "臺北市信義區信義路六段81號", title: "臺北市流浪貓保護協會")
            //臺北市信義區信義路六段81號 臺北市流浪貓保護協會
        }else if position.contains("動物保護處"){
            getMap(geocoderAdd: "台北市信義區吳興街600巷109號", title: "臺北市動物保護處")
            //台北市信義區吳興街600巷109號
        }else if position.contains("愛兔協會"){
            getMap(geocoderAdd: "台北市內湖區內湖路一段73號3樓", title: "愛兔協會")
            //台北市內湖區內湖路一段73號3樓
        }else{
            let alert = UIAlertController(title: "暫無資料", message: "目前無該地址資料", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtn)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    fileprivate func changTypeClick() {
        typeCount += 1
        switch typeCount % 3 {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            return
        }
    }
    
}

// MARK:- 取得地圖
extension MapViewController {
    
    fileprivate func getMap(geocoderAdd:String, title:String){
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(geocoderAdd) {
            placemarks, err in
            guard err == nil else {
                return
            }
            let placemark = placemarks?[0]
            let annotation = MKPointAnnotation()
            annotation.title = title
            if let location = placemark?.location {
                
                annotation.coordinate = location.coordinate
                
                self.animalCoordinate = location.coordinate
                
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
}

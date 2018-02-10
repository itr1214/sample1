//
//  MapViewController.swift
//  sample1
//
//  Created by 岡田 一郎 on 2018/02/10.
//  Copyright © 2018年 Ichirou Okada. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    var region:CLRegion!


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //位置情報を取得する為の設定
        self.locationManager=CLLocationManager()
        self.locationManager.requestAlwaysAuthorization() //認証用。ios8以上だと必須
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation //測定の制度を設定
        self.locationManager.pausesLocationUpdatesAutomatically=false //位置情報が自動的にOFFにならない様に設定
//        self.locationManager.distanceFilter=100.0// 100m以上移動した場合に位置情報を取得
        self.locationManager.delegate=self
        
        //位置情報使用許可のリクエストを表示するメソッドの呼び出し
        self.locationManager.requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        //ジオフェンスの設定
//        var cordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.7020691,139.7753269)
//        self.region = CLCircularRegion(center:cordinate , radius:100.0, identifier:"roppongi")
        
        //現在地の取得を開始
        self.locationManager.startUpdatingLocation()
        
        //ジオフェンス監視を開始
//        self.locationManager.startMonitoring(for: self.region)
        
        // 縮尺を変更.
        // 倍率を指定.
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        // MapViewで指定した中心位置とMKCoordinateSapnで宣言したspanを指定する.
        var region : MKCoordinateRegion = MKCoordinateRegion(center: (locationManager.location?.coordinate)!, span: span)
//        region.center = mapView.userLocation.coordinate
//        region.center = (locationManager.location?.coordinate)!
        mapView.region = region
    }
    //現在地の情報を取得(startUpdatingLocationを呼ぶと自動的に呼ばれる)
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        print("aaaaa")
//
//        //現在地を基準に地図を表示 縮尺の設定
//        let centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(manager.location!.coordinate.latitude,manager.location!.coordinate.longitude)
//        let span = MKCoordinateSpanMake(0.003, 0.003)
//        let centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
//        mapView.setRegion(centerPosition, animated: true)
//        print("bbbb")
//    }
    //ジオフェンスが起動した際に呼び出される
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("DEBUG: ジオフェンス")
        //ジオフェンスの範囲表示用
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.7020691,139.7753269)


        //アノテーション表示用設定(Pinの設定)
        var myPin:MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = center
        self.mapView.addAnnotation(myPin)

        //サークル表示用設定
        let circle:MKCircle = MKCircle(center: center, radius: 100)
        self.mapView.add(circle)
    }
//    ジオフェンス領域に侵入した際に呼び出される
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {

    }

    //ジオフェンス領域から出た際に呼び出される
    func locationManager(_ manager: CLLocationManager!, didExitRegion region: CLRegion!) {

    }

    //ジオフェンスの情報が取得出来ない際に呼び出される
    func locationManager(_ manager: CLLocationManager!, didFailWithError error: Error!) {

    }

//    地図に各種情報を描画する際に呼び出される(addOverlayを呼ぶと自動的に呼ばれる)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //サークルを地図上に描画
        let render:MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        render.strokeColor = UIColor.red
        render.fillColor = UIColor.red.withAlphaComponent(0.4)
        render.lineWidth=1
        return render
    }

    //位置情報取得に失敗したときに呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報取得に失敗しました。")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

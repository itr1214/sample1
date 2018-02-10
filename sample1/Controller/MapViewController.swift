//
//  MapViewController.swift
//  sample1
//
//  Created by 岡田 一郎 on 2018/02/10.
//  Copyright © 2018年 Ichirou Okada. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    var region:CLRegion!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //位置情報を取得する為の設定
        self.locationManager=CLLocationManager()
        self.locationManager.requestAlwaysAuthorization() //認証用。ios8以上だと必須
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation //測定の制度を設定
        self.locationManager.pausesLocationUpdatesAutomatically=false //位置情報が自動的にOFFにならない様に設定
        self.locationManager.distanceFilter=100.0// 100m以上移動した場合に位置情報を取得
        self.locationManager.delegate=self
        print("DEBUG: \(mapView.userLocation.location)")

        //ジオフェンスの設定
        var cordinate:CLLocationCoordinate2D=CLLocationCoordinate2DMake(35.7020691,139.7753269)
        self.region = CLCircularRegion(center:cordinate , radius:100.0, identifier:"roppongi")
        
        //現在地の取得を開始
        self.locationManager.startUpdatingLocation()
        //ジオフェンス監視を開始
        self.locationManager.startMonitoring(for: self.region)
    }
    
    //現在地の情報を取得(startUpdatingLocationを呼ぶと自動的に呼ばれる)
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        println("test1")
        
        //現在地を基準に地図を表示
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(manager.location!.coordinate.latitude,manager.location!.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.003, 0.003)
        let centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        mapView.setRegion(centerPosition, animated: true)
        
    }
    
    //ジオフェンスが起動した際に呼び出される
    func locationManager(_ manager: CLLocationManager!, didStartMonitoringFor region: CLRegion!) {
//        println("test2")
        
        //ジオフェンスの範囲表示用
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.7020691,139.7753269)
        
        //アノテーション表示用設定
        var myPin:MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = center
        self.mapView.addAnnotation(myPin)
        
        //サークル表示用設定
//        var circle:MKCircle = MKCircle(centerCoordinate:center , radius:100)
        let circle:MKCircle = MKCircle(center: center, radius: 100)
        self.mapView.add(circle)
    }
    
    //ジオフェンス領域に侵入した際に呼び出される
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
//        println("test3")
    }
    
    //ジオフェンス領域から出た際に呼び出される
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
//        println("test4")
    }
    
    //ジオフェンスの情報が取得出来ない際に呼び出される
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        println("test5")
    }
    
    //地図に各種情報を描画する際に呼び出される(addOverlayを呼ぶと自動的に呼ばれる)
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//        println("test6")
        
        //サークルを地図上に描画
        var render:MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        render.strokeColor = UIColor.red
        render.fillColor = UIColor.red.withAlphaComponent(0.4)
        render.lineWidth=1
        return render
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  LocationService.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 12/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func locationOn()
    func locationOff()
    func locationDidUpdate(location: CLLocation)
}

extension LocationServiceDelegate {
    // Make protocol methods optional
    func locationOn() { }
    func locationOff() { }
    func locationDidUpdate(location: CLLocation) { }
}

class LocationService: NSObject {
    
    // Singleton
    static let shared = LocationService()
    
    weak var delegate: LocationServiceDelegate?
    
    private var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation {
        return locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    var locationStatus: Bool = false
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //requestAlwaysAuthorization()
        
//        locationManager.activityType = .automotiveNavigation // Currently affects behavior such as the determination of when location updates may be automatically paused
//        locationManager.allowsBackgroundLocationUpdates = true // For background
//        locationManager.distanceFilter = CLLocationDistance(10) // Specifies the minimum update distance in meters.
    }
    
    // MARK: - Actions
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        delegate?.locationDidUpdate(location: newLocation)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationStatus = true
            delegate?.locationOn()
            locationManager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            locationStatus = false
            delegate?.locationOff()
        @unknown default:
            print("Unknown case!")
            locationStatus = false
            delegate?.locationOff()
        }
    }
}

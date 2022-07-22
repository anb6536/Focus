//
//  LocationManager.swift
//  Focus
//
//  Created by Aahish Balimane on 4/4/22.
//

import Foundation
import CoreLocation
import Combine  // Helps working with observable object

class LocationManager: NSObject, ObservableObject {
    let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var locationError: Bool? {
        willSet { objectWillChange.send() }
    }
    
    @Published var permissionsError: Bool? {
        willSet { objectWillChange.send() }
    }
    
    @Published var status: CLAuthorizationStatus? {
        willSet { objectWillChange.send() }
    }
    
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
    }
    
    @Published var placemark: CLPlacemark? {
        willSet { objectWillChange.send() }
    }
    
    override init() {
        super.init()
        
        //Configure the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    private func geocode() {
        guard let location = self.location else { return }
        
        geocoder.reverseGeocodeLocation(location) { places, error in
            if error == nil {
                self.placemark = places?[0]
            } else {
                self.placemark = nil
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted:
            self.permissionsError = true
            return
        case .denied:
            self.permissionsError = true
            return
        case .notDetermined:
            self.permissionsError = true
            return
        case .authorizedWhenInUse:
            self.permissionsError = false
            return
        case .authorizedAlways:
            self.permissionsError = false
            return
        @unknown default:
            self.permissionsError = true
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.location = location
        self.locationError = false
        self.geocode()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError = true
    }
}

//
//  GeofenceManager.swift
//  Plugin
//
//  Created by Jille van der Weerd on 05/02/2019.
//  Copyright © 2019 Max Lynch. All rights reserved.
//

import Foundation
import CoreLocation

class GeofenceManager: NSObject {
    
    // Singleton instance
    static let shared = GeofenceManager()
    
    private let locationManager = CLLocationManager()
    
    var notifyOnEntry = true
    
    var notifyOnExit = true
    
    var backendUrl: URL? = URL(string: "937ed932.ngrok.io")
    
    var payload = [String: Any]()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    /**
    Request access to location data, in the background and while using the app.
    */
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    
    
    /**
     Check whether the app has the ability to monitor a geofence region.
     - returns:
     A Boolean indicating availability of geofencing and authorizationstatus.
    */
    private func geofenceAvailable() -> Bool {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            return false
        }
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    /**
     Creates a CLCircularRegion.
     - returns:
     A CLCircularRegion created from the given parameters.
     - parameters:
        - lat: The latitude of the center of the circle.
        - lng: The longitude of the center of the circle.
        - radius: The radius of the circle.
        - identifier: A string to identify the circle.
    */
    func geofenceRegion(lat: Double, lng: Double, radius: Double = 50, identifier: String) -> CLCircularRegion {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        region.notifyOnEntry = notifyOnEntry
        region.notifyOnExit = notifyOnExit
        return region
    }
    
    func startMonitoring(region: CLCircularRegion) -> Bool {
        if geofenceAvailable() {
            locationManager.startMonitoring(for: region)
            return true
        }
        return false
    }
    
    func stopMonitoring(identifier: String) -> Bool {
        for region in locationManager.monitoredRegions {
            guard let cr = region as? CLCircularRegion, cr.identifier == identifier else { continue }
            locationManager.stopMonitoring(for: cr)
            return true
        }
        return false
    }
    
    func monitoredRegionsCount() -> Int {
        return locationManager.monitoredRegions.count
    }
    
    func monitoredRegions() -> [String] {
        return locationManager.monitoredRegions.map({ $0.identifier })
    }
    
    private func handleEvent(forRegion region: CLRegion, enter: Bool) {
        let identifer = region.identifier
        payload["identifier"] = identifer
        payload["enter"] = enter
        
        guard let body = try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted) else { return }
        
        var request = URLRequest(url: backendUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
//            guard error == nil, response != nil else { return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("Post request finished with response code: \(httpResponse.statusCode).")
        }
    }
    
}

extension GeofenceManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location authorization changed to \(status).")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier).")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error).")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region, enter: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region, enter: false)
        }
    }
}

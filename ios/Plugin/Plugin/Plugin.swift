import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(CapacitorGeofencing)
public class CapacitorGeofencing: CAPPlugin {
    
    @objc func setup(_ call: CAPPluginCall) {
        // Check if all properties are present
        guard let backendUrl = call.getString("url") else {
            call.error("Must provide url.")
            return
        }
        guard let notifyOnEntry = call.getBool("notifyOnEntry", nil) else {
            call.error("Must provide notifyOnEntry.")
            return
        }
        guard let notifyOnExit = call.getBool("notifyOnExit", nil) else {
            call.error("Must provide notifyOnExit.")
            return
        }
        guard let payload = call.getObject("payload") else {
            call.error("Must provide payload.")
            return
        }
        
        guard let url = URL(string: backendUrl) else {
            call.error("Given url isn't valid.")
            return
        }
        
        GeofenceManager.shared.backendUrl = url
        GeofenceManager.shared.notifyOnEntry = notifyOnEntry
        GeofenceManager.shared.notifyOnExit = notifyOnExit
        GeofenceManager.shared.payload = payload
        GeofenceManager.shared.requestAlwaysAuthorization { (success) in
            if success {
                call.success()
            } else {
                call.error("User did not give 'alwaysAuthorization' permission.")
            }
        }
    }
    
    @objc func addRegion(_ call: CAPPluginCall) {
        // Check if all properties are present
        guard let lat = call.get("latitude", Double.self) else {
            call.error("Must provied latitude.")
            return
        }
        guard let lng = call.get("longitude", Double.self) else {
            call.error("Must provide longitude.")
            return
        }
        guard let identifer = call.getString("identifier") else {
            call.error("Must provide identifier.")
            return
        }
        let radius = call.get("radius", Double.self) ?? 50
        
        let region = GeofenceManager.shared.geofenceRegion(lat: lat, lng: lng, radius: radius, identifier: identifer)
        GeofenceManager.shared.startMonitoring(region: region)
            ? call.success()
            : call.error("Could not start monitoring the region.")
    }
    
    @objc func stopMonitoring(_ call: CAPPluginCall) {
        guard let identifier = call.getString("identifier") else {
            call.error("Must provide identifier.")
            return
        }
        GeofenceManager.shared.stopMonitoring(identifier: identifier)
            ? call.success()
            : call.error("Could not find a region with that identifer.")
    }
    
    @objc func monitoredRegions(_ call: CAPPluginCall) {
        call.success([
            "regions": GeofenceManager.shared.monitoredRegions()
        ])
    }
}


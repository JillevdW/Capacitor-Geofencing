# Capacitor Geofencing

[![npm version](https://badge.fury.io/js/capacitor-geofencing.svg)](https://badge.fury.io/js/capacitor-geofencing)

This is a plugin for Capacitor that exposes native iOS geofencing capabilities to your capacitor app. 



## Why?

We needed a way to find out when users enter and exit a region in a capacitor app that would only be built for iOS. Since we can't wake the entire hybrid part of the app to handle a callback or a promise, we need to handle everything natively. This plugin handles that by taking an url to which it will send a payload when users enter or leave the registered regions.



## Installation

`npm i capacitor-geofencing`



## Configuration

The plugin needs some configuration:

```typescript
import { Plugins } from "@capacitor/core";
import { CapacitorGeofencingPlugin } from "capacitor-geofencing";
let { CapacitorGeofencing } = Plugins;

CapacitorGeofencing.setup({
    url: "", 				// Endpoint to which the plugin will POST the payload.
    notifyOnEntry: true, 	// Whether the plugin will notify on entry yes or no.
    notifyOnExit: true,		// Whether the plugin will notify on exit yes or no.
    payload: {}				// Object that will be sent to the server.
}); // This returns a promise with a success/error message.
```

You also need to add the following keys to your info.plist file:

```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Reason for always usage.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Reasen for when in usage.</string>
```



## Register a region

After setting up the plugin you can register regions.

```typescript
CapacitorGeofencing.addRegion({
    latitude: 37.33182,
    longitude: 122.03118,
    identifier: "infinite-loop",
    radius: 500
});	// This returns a promise with a success/error message.
```



## Stop monitoring a region

When you're done monitoring a region, you can remove it by supplying the identifier.

```typescript
CapacitorGeofencing.stopMonitoring({
    identifier: "infinite-loop"
});	// This returns a promise with a success/error message.
```



## List all monitored regions

This lists the identifiers of the regions that are currently being monitored.

```typescript
CapacitorGeofencing.monitoredRegions()
    .then(regions => {
    	// regions is an array of Strings.
    });
```

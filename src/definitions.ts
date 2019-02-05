declare global {
  interface PluginRegistry {
    CapacitorGeofencing?: CapacitorGeofencingPlugin;
  }
}

export interface CapacitorGeofencingPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
  setup(options: { url: string, notifyOnEntry: boolean, notifyOnExit: boolean, payload: object }): Promise<{value: string}>;
  addRegion(options: { latitude: number, longitude: number, identifier: string }): Promise<{value: string}>;
  stopMonitoring(options: { identifier: string }): Promise<{value: string}>;
  monitoredRegions(): Promise<{value: string}>;
}

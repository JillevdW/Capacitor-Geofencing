declare global {
  interface PluginRegistry {
    CapacitorGeofencing?: CapacitorGeofencingPlugin;
  }
}

export interface CapacitorGeofencingPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
}

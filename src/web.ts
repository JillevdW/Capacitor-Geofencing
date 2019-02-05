import { WebPlugin } from '@capacitor/core';
import { CapacitorGeofencingPlugin } from './definitions';

export class CapacitorGeofencingWeb extends WebPlugin implements CapacitorGeofencingPlugin {
  constructor() {
    super({
      name: 'CapacitorGeofencing',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return options;
  }
}

const CapacitorGeofencing = new CapacitorGeofencingWeb();

export { CapacitorGeofencing };

import { registerPlugin } from '@capacitor/core';

import type { PushProvisioningCapacitorPluginPlugin } from './definitions';

const PushProvisioningCapacitorPlugin =
    registerPlugin<PushProvisioningCapacitorPluginPlugin>(
        'PushProvisioningCapacitorPlugin',
        {},
    );

export * from './definitions';
export { PushProvisioningCapacitorPlugin };

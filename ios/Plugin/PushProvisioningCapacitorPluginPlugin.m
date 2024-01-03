#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(PushProvisioningCapacitorPluginPlugin, "PushProvisioningCapacitorPlugin",
           CAP_PLUGIN_METHOD(isAvailable, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isPaired, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getCardUrl, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(startEnroll, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(completeEnroll, CAPPluginReturnPromise);
)

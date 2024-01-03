package com.fiwind.plugins.capacitor.pushprovisioning;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "PushProvisioningCapacitorPlugin")
public class PushProvisioningCapacitorPluginPlugin extends Plugin {

    @PluginMethod
    public void isAvailable(PluginCall call) {
        // FIXME: Not implemented
        JSObject ret = new JSObject();
        ret.put("available", true);
        call.resolve(ret);
    }

    @PluginMethod
    public void isPaired(PluginCall call) {
        // FIXME: Not implemented
        JSObject ret = new JSObject();
        ret.put("paired", false);
        call.resolve(ret);
    }

    @PluginMethod
    public void getCardUrl(PluginCall call) {
        // FIXME: Not implemented
        JSObject ret = new JSObject();
        ret.put("url", null);
        call.resolve(ret);
    }

    @PluginMethod
    public void startEnroll(PluginCall call) {
        call.reject("startEnroll() is not implemented yet");
    }

    @PluginMethod
    public void completeEnroll(PluginCall call) {
        call.reject("completeEnroll() is not implemented yet");
    }
}

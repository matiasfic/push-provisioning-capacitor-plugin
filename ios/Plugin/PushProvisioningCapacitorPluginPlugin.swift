import Foundation
import Capacitor
import PassKit

@objc(PushProvisioningCapacitorPluginPlugin)
public class PushProvisioningCapacitorPluginPlugin: CAPPlugin {
    
    private var enrollCall: CAPPluginCall?
    private var completionHandler: ((PKAddPaymentPassRequest) -> Void)?

    @objc func isAvailable(_ call: CAPPluginCall) {
        call.resolve([
            "available": isPassKitAvailable()
        ])
    }
    
    @objc func isPaired(_ call: CAPPluginCall) {
        guard let lastFour = call.getString("cardLastFour") else {
            call.reject("Missing cardLastFour parameter")
            return
        }

        call.resolve([
            "paired": isCardPaired(lastFour: lastFour)
        ])
    }
    
    @objc func getCardUrl(_ call: CAPPluginCall) {
        guard let lastFour = call.getString("cardLastFour") else {
            call.reject("Missing cardLastFour parameter")
            return
        }
        
        call.resolve([
            "url": getCard(lastFour: lastFour)?.passURL?.absoluteString ?? NSNull()
        ])
    }
    
    @objc func startEnroll(_ call: CAPPluginCall) {
        guard isPassKitAvailable() else {
            call.reject("Apple Pay is not available on this device")
            return
        }
        
        guard let cardHolder = call.getString("cardHolder"),
              let cardLastFour = call.getString("cardLastFour") else {
            call.reject("Missing required parameters")
            return
        }
        
        self.enrollCall = call
        
        guard PKAddPaymentPassViewController.canAddPaymentPass() else {
            call.reject("Apple Pay is not available on this device")
            return
        }
        
        guard let configuration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .ECC_V2) else {
            call.reject("Apple Pay is not available on this device")
            return
        }
        configuration.cardholderName = cardHolder
        configuration.primaryAccountSuffix = cardLastFour
        
        guard let viewController = PKAddPaymentPassViewController(requestConfiguration: configuration, delegate: self) else {
            call.reject("Error initializing Apple Pay enrollment")
            return
        }
        
        DispatchQueue.main.async {
            self.bridge?.viewController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func completeEnroll(_ call: CAPPluginCall) {
        guard let handler=self.completionHandler else {
            call.reject("completionHandler reference missing")
            return
        }
        
        guard let activationData = call.getString("activationData"),
              let ephemeralPublicKey = call.getString("ephemeralPublicKey"),
              let encryptedPassData = call.getString("encryptedPassData") else {
            call.reject("Missing required parameters")
            return
        }
        
        print("activationData: \(activationData)")
        print("ephemeralPublicKey: \(ephemeralPublicKey)")
        print("encryptedPassData: \(ephemeralPublicKey)")
        
        let paymentPassRequest = PKAddPaymentPassRequest()
        paymentPassRequest.activationData = Data(base64Encoded: activationData)
        paymentPassRequest.ephemeralPublicKey = Data(base64Encoded: ephemeralPublicKey)
        paymentPassRequest.encryptedPassData = Data(base64Encoded: encryptedPassData)
        handler(paymentPassRequest)
    }
    
    private func isPassKitAvailable() -> Bool {
        return PKAddPaymentPassViewController.canAddPaymentPass()
    }
    
    private func isCardPaired(lastFour: String) -> Bool {
        return getCard(lastFour: lastFour) != nil
    }
    
    private func getCard(lastFour: String) -> PKPass? {
        let passes = PKPassLibrary().passes()
    
        for pass in passes {
            if pass.localizedDescription == "Fiwind" && pass.paymentPass?.primaryAccountNumberSuffix == lastFour {
                return pass;
            }
        }
        
        return nil
    }
    
}

extension PushProvisioningCapacitorPluginPlugin: PKAddPaymentPassViewControllerDelegate {
    
    // Listener para contactar al backend y obtener la información que generamos desde Pomelo.
    public func addPaymentPassViewController(
        _ controller: PKAddPaymentPassViewController,
        generateRequestWithCertificateChain certificates: [Data],
        nonce: Data,
        nonceSignature: Data,
        completionHandler handler: @escaping (PKAddPaymentPassRequest) -> Void
    ) {
        guard let call=self.enrollCall else {
            print("Missing enrollCall reference")
            return
        }
        self.completionHandler = handler
        call.resolve([
            "certificates": certificates.map { certificate in certificate.base64EncodedString() },
            "nonce": nonce.base64EncodedString(),
            "nonceSignature": nonceSignature.base64EncodedString()
        ])
    }
    
    // Listener sobre el resultado de aprovisionamiento
    public func addPaymentPassViewController(
        _ controller: PKAddPaymentPassViewController,
        didFinishAdding pass: PKPaymentPass?,
        error: Error?
    ) {
        if let _ = pass {
            print("Apple Pay provisioning success")
            self.enrollCall = nil;
            self.completionHandler = nil;
        } else {
            print("Apple Pay provisioning error \(String(describing: error))")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

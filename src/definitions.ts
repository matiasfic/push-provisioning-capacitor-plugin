export interface PushProvisioningCapacitorPluginPlugin {
  isAvailable(): Promise<{ available: boolean }>;
  isPaired(options: {cardLastFour: string}): Promise<{ paired: boolean }>;
  getCardUrl(options: {cardLastFour: string}): Promise<{ url: string | null }>;
  startEnroll(options: {cardHolder: string, cardLastFour: string }): Promise<{ certificates: string[], nonce: string, nonceSignature: string }>;
  completeEnroll(options: { activationData: string, encryptedPassData: string, ephemeralPublicKey: string }): Promise<void>;
}

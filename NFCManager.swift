import Foundation
import CoreNFC

class NFCManager: NSObject, ObservableObject {
    @Published var isScanning = false
    @Published var lastScannedTag: NFCNDEFMessage?
    
    private var session: NFCNDEFReaderSession?
    
    func startScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC n'est pas disponible sur cet appareil")
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self,
                                     queue: DispatchQueue.main,
                                     invalidateAfterFirstRead: false)
        session?.alertMessage = "Approchez votre iPhone d'une carte NFC"
        session?.begin()
        isScanning = true
    }
    
    func stopScanning() {
        session?.invalidate()
        isScanning = false
    }
}

extension NFCManager: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.isScanning = false
        }
        print("La session NFC a été invalidée avec l'erreur : \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let message = messages.first else { return }
        
        DispatchQueue.main.async {
            self.lastScannedTag = message
            self.isScanning = false
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("La session NFC est active")
    }
} 
import SwiftUI
import CoreNFC

@main
struct NFCCardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var nfcManager = NFCManager()
    @State private var showingCardCreation = false
    @State private var savedCards: [VirtualCard] = []
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Cartes virtuelles")) {
                    ForEach(savedCards) { card in
                        VirtualCardRow(card: card)
                    }
                }
            }
            .navigationTitle("Mes Cartes NFC")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCardCreation = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        nfcManager.startScanning()
                    }) {
                        Image(systemName: "wave.3.right")
                    }
                }
            }
            .sheet(isPresented: $showingCardCreation) {
                CardCreationView(savedCards: $savedCards)
            }
        }
    }
}

struct VirtualCardRow: View {
    let card: VirtualCard
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(card.name)
                .font(.headline)
            Text(card.identifier)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
} 
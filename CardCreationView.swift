import SwiftUI

struct CardCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var savedCards: [VirtualCard]
    
    @State private var cardName = ""
    @State private var selectedType: CardType = .accessCard
    @State private var showingNFCReader = false
    @State private var scannedData: Data?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations de la carte")) {
                    TextField("Nom de la carte", text: $cardName)
                    
                    Picker("Type de carte", selection: $selectedType) {
                        Text("Carte d'accès").tag(CardType.accessCard)
                        Text("Carte de transport").tag(CardType.transitCard)
                        Text("Carte de paiement").tag(CardType.paymentCard)
                        Text("Autre").tag(CardType.other)
                    }
                }
                
                Section {
                    Button(action: {
                        showingNFCReader = true
                    }) {
                        HStack {
                            Image(systemName: "wave.3.right")
                            Text("Scanner une carte NFC")
                        }
                    }
                }
                
                if scannedData != nil {
                    Section {
                        Button(action: saveCard) {
                            Text("Sauvegarder la carte")
                        }
                    }
                }
            }
            .navigationTitle("Nouvelle Carte")
            .navigationBarItems(trailing: Button("Annuler") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveCard() {
        guard let data = scannedData else { return }
        
        let newCard = VirtualCard(
            name: cardName,
            identifier: UUID().uuidString,
            cardType: selectedType,
            data: data
        )
        
        CardStorage.shared.saveCard(newCard)
        savedCards = CardStorage.shared.getAllCards()
        presentationMode.wrappedValue.dismiss()
    }
} 
import Foundation

struct VirtualCard: Identifiable, Codable {
    let id: UUID
    let name: String
    let identifier: String
    let cardType: CardType
    let data: Data
    let createdAt: Date
    
    init(name: String, identifier: String, cardType: CardType, data: Data) {
        self.id = UUID()
        self.name = name
        self.identifier = identifier
        self.cardType = cardType
        self.data = data
        self.createdAt = Date()
    }
}

enum CardType: String, Codable {
    case accessCard
    case transitCard
    case paymentCard
    case other
}

class CardStorage {
    static let shared = CardStorage()
    private let userDefaults = UserDefaults.standard
    private let cardsKey = "savedVirtualCards"
    
    private init() {}
    
    func saveCard(_ card: VirtualCard) {
        var cards = getAllCards()
        cards.append(card)
        if let encoded = try? JSONEncoder().encode(cards) {
            userDefaults.set(encoded, forKey: cardsKey)
        }
    }
    
    func getAllCards() -> [VirtualCard] {
        guard let data = userDefaults.data(forKey: cardsKey),
              let cards = try? JSONDecoder().decode([VirtualCard].self, from: data) else {
            return []
        }
        return cards
    }
    
    func deleteCard(withId id: UUID) {
        var cards = getAllCards()
        cards.removeAll { $0.id == id }
        if let encoded = try? JSONEncoder().encode(cards) {
            userDefaults.set(encoded, forKey: cardsKey)
        }
    }
} 
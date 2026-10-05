import SwiftUI

struct Agent: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let role: String
    let ability: String
    let symbol: String
}

struct Weapon: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    let price: Int
    let damage: Int
    let magazine: Int
}

@MainActor
final class PlayerProfile: ObservableObject {
    @Published var credits: Int = 800
    @Published var selectedAgentName = "Nova"
    @Published var selectedWeaponName = "Kestrel"
    @Published var masterVolume: Double = 0.8
    @Published var haptics = true

    let agents: [Agent] = [
        Agent(name: "Nova", role: "Dueliste", ability: "Dash photonique", symbol: "sparkles"),
        Agent(name: "Bastion", role: "Sentinelle", ability: "Bouclier cinétique", symbol: "shield.fill"),
        Agent(name: "Echo", role: "Initiateur", ability: "Impulsion sonar", symbol: "wave.3.right"),
        Agent(name: "Vesper", role: "Contrôleur", ability: "Nuage obscur", symbol: "cloud.fog.fill")
    ]

    let weapons: [Weapon] = [
        Weapon(name: "Kestrel", category: "Pistolet", price: 0, damage: 26, magazine: 12),
        Weapon(name: "Vector-9", category: "PM", price: 900, damage: 20, magazine: 24),
        Weapon(name: "Axiom", category: "Fusil", price: 1700, damage: 38, magazine: 25),
        Weapon(name: "Longshot", category: "Précision", price: 2400, damage: 90, magazine: 5)
    ]

    func selectedWeapon() -> Weapon {
        weapons.first(where: { $0.name == selectedWeaponName }) ?? weapons[0]
    }
}

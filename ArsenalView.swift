import SwiftUI

struct ArsenalView: View {
    @EnvironmentObject private var profile: PlayerProfile

    var body: some View {
        List(profile.weapons) { weapon in
            Button {
                if weapon.price == 0 || profile.credits >= weapon.price {
                    if weapon.name != profile.selectedWeaponName && weapon.price > 0 {
                        profile.credits -= weapon.price
                    }
                    profile.selectedWeaponName = weapon.name
                }
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: weapon.category == "Précision" ? "scope" : "dot.scope")
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                    VStack(alignment: .leading) {
                        Text(weapon.name).font(.headline)
                        Text("\(weapon.category) • dégâts \(weapon.damage) • chargeur \(weapon.magazine)")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    if profile.selectedWeaponName == weapon.name {
                        Image(systemName: "checkmark.circle.fill")
                    } else {
                        Text(weapon.price == 0 ? "GRATUIT" : "\(weapon.price)")
                            .font(.caption.bold())
                    }
                }
                .padding(.vertical, 6)
            }
            .buttonStyle(.plain)
        }
        .scrollContentBackground(.hidden)
        .background(Color(red: 0.035, green: 0.055, blue: 0.09))
        .navigationTitle("Armurerie")
    }
}

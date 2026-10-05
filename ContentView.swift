import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var profile: PlayerProfile
    @State private var path: [Destination] = []

    enum Destination: Hashable {
        case play, agents, arsenal, settings
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.035, green: 0.055, blue: 0.09), Color(red: 0.10, green: 0.02, blue: 0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()
                    Image(systemName: "scope")
                        .font(.system(size: 72, weight: .black))
                        .foregroundStyle(.white)
                    Text("STRIKE PROTOCOL")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .tracking(2)
                    Text("Tactical 5v5 — Prototype iOS")
                        .foregroundStyle(.secondary)

                    VStack(spacing: 12) {
                        MenuButton(title: "JOUER", icon: "play.fill") { path.append(.play) }
                        MenuButton(title: "AGENTS", icon: "person.3.fill") { path.append(.agents) }
                        MenuButton(title: "ARMURERIE", icon: "scope") { path.append(.arsenal) }
                        MenuButton(title: "RÉGLAGES", icon: "gearshape.fill") { path.append(.settings) }
                    }
                    .frame(maxWidth: 420)

                    HStack {
                        Label(profile.selectedAgentName, systemImage: "person.crop.circle.fill")
                        Spacer()
                        Label("\(profile.credits)", systemImage: "creditcard.fill")
                    }
                    .font(.subheadline.bold())
                    .padding(14)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .frame(maxWidth: 420)
                    Spacer()
                }
                .padding()
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .play: GameView()
                case .agents: AgentSelectionView()
                case .arsenal: ArsenalView()
                case .settings: SettingsView()
                }
            }
        }
        .tint(.white)
    }
}

private struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon).frame(width: 30)
                Text(title).font(.headline.weight(.black))
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal, 18)
            .frame(height: 58)
            .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.12)))
        }
        .buttonStyle(.plain)
    }
}

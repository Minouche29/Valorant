import SwiftUI

struct AgentSelectionView: View {
    @EnvironmentObject private var profile: PlayerProfile

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 14)], spacing: 14) {
                ForEach(profile.agents) { agent in
                    Button {
                        profile.selectedAgentName = agent.name
                    } label: {
                        VStack(spacing: 12) {
                            Image(systemName: agent.symbol)
                                .font(.system(size: 42, weight: .bold))
                            Text(agent.name).font(.title3.bold())
                            Text(agent.role).font(.caption).foregroundStyle(.secondary)
                            Text(agent.ability)
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 170)
                        .padding()
                        .background(profile.selectedAgentName == agent.name ? .white.opacity(0.18) : .white.opacity(0.07), in: RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(profile.selectedAgentName == agent.name ? .white : .white.opacity(0.12), lineWidth: 2))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Agents")
        .background(Color(red: 0.035, green: 0.055, blue: 0.09).ignoresSafeArea())
    }
}

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var profile: PlayerProfile

    var body: some View {
        Form {
            Section("Audio") {
                Slider(value: $profile.masterVolume, in: 0...1) {
                    Text("Volume")
                }
                Text("Volume : \(Int(profile.masterVolume * 100)) %")
            }
            Section("Contrôles") {
                Toggle("Vibrations", isOn: $profile.haptics)
                Text("Déplace-toi avec le joystick en bas à gauche. Touche l'arène pour tirer.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Réglages")
    }
}

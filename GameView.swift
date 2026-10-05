import SwiftUI
import Combine

private struct TrainingTarget: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var hp: Int
}

struct GameView: View {
    @EnvironmentObject private var profile: PlayerProfile
    @State private var player = CGPoint(x: 0.5, y: 0.72)
    @State private var joystick = CGSize.zero
    @State private var targets: [TrainingTarget] = [
        .init(x: 0.25, y: 0.24, hp: 100),
        .init(x: 0.52, y: 0.30, hp: 100),
        .init(x: 0.77, y: 0.19, hp: 100),
        .init(x: 0.68, y: 0.53, hp: 100)
    ]
    @State private var ammo = 12
    @State private var round = 1
    @State private var score = 0
    @State private var buyPhase = true
    @State private var message = "PHASE D'ACHAT"

    private let timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.025, green: 0.035, blue: 0.055).ignoresSafeArea()

                arena(size: geo.size)

                VStack {
                    hud
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.top, 8)

                VStack {
                    Spacer()
                    controls
                }
                .padding(20)
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                SpatialTapGesture().onEnded { value in
                    guard !buyPhase else { return }
                    shoot(at: value.location, size: geo.size)
                }
            )
            .onReceive(timer) { _ in
                movePlayer()
            }
            .onAppear {
                ammo = profile.selectedWeapon().magazine
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("ENTRAÎNEMENT").font(.headline.weight(.black))
            }
        }
    }

    private func arena(size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.045))
                .overlay(grid)
                .padding(.horizontal, 10)
                .padding(.vertical, 70)

            ForEach(targets) { target in
                if target.hp > 0 {
                    ZStack {
                        Circle().fill(.red.opacity(0.75))
                        Circle().stroke(.white.opacity(0.7), lineWidth: 2)
                        Text("\(target.hp)")
                            .font(.caption2.bold())
                    }
                    .frame(width: 46, height: 46)
                    .position(x: target.x * size.width, y: target.y * size.height)
                }
            }

            ZStack {
                Circle().fill(.cyan.opacity(0.9))
                Image(systemName: "location.north.fill")
                    .foregroundStyle(.black)
            }
            .frame(width: 44, height: 44)
            .position(x: player.x * size.width, y: player.y * size.height)
        }
    }

    private var grid: some View {
        Canvas { context, size in
            var path = Path()
            let spacing: CGFloat = 44
            var x: CGFloat = 0
            while x < size.width {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                x += spacing
            }
            var y: CGFloat = 0
            while y < size.height {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                y += spacing
            }
            context.stroke(path, with: .color(.white.opacity(0.04)), lineWidth: 1)
        }
    }

    private var hud: some View {
        HStack(spacing: 12) {
            Text("MANCHE \(round)")
            Spacer()
            Text(message)
                .foregroundStyle(buyPhase ? .yellow : .green)
            Spacer()
            Label("\(score)", systemImage: "target")
            Label("\(ammo)", systemImage: "magazine.fill")
        }
        .font(.caption.weight(.black))
        .padding(12)
        .background(.black.opacity(0.45), in: Capsule())
    }

    private var controls: some View {
        HStack(alignment: .bottom) {
            joystickView
            Spacer()
            VStack(spacing: 12) {
                if buyPhase {
                    Button("COMMENCER") {
                        buyPhase = false
                        message = "COMBAT"
                        ammo = profile.selectedWeapon().magazine
                    }
                    .font(.caption.bold())
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(.green.opacity(0.85), in: Capsule())
                } else {
                    Button {
                        ammo = profile.selectedWeapon().magazine
                        message = "RECHARGEMENT"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            message = "COMBAT"
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2.bold())
                            .frame(width: 58, height: 58)
                            .background(.white.opacity(0.14), in: Circle())
                    }
                }
            }
        }
    }

    private var joystickView: some View {
        ZStack {
            Circle().fill(.white.opacity(0.08))
                .frame(width: 112, height: 112)
            Circle().fill(.white.opacity(0.22))
                .frame(width: 48, height: 48)
                .offset(joystick)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let dx = value.translation.width
                    let dy = value.translation.height
                    let length = max(1, sqrt(dx * dx + dy * dy))
                    let maxRadius: CGFloat = 34
                    let scale = min(1, maxRadius / length)
                    joystick = CGSize(width: dx * scale, height: dy * scale)
                }
                .onEnded { _ in
                    joystick = .zero
                }
        )
    }

    private func movePlayer() {
        guard !buyPhase else { return }
        let speed: CGFloat = 0.0008
        player.x = min(0.94, max(0.06, player.x + joystick.width * speed))
        player.y = min(0.88, max(0.14, player.y + joystick.height * speed))
    }

    private func shoot(at point: CGPoint, size: CGSize) {
        guard ammo > 0 else {
            message = "CHARGEUR VIDE"
            return
        }
        ammo -= 1
        let weapon = profile.selectedWeapon()
        var hit = false

        for index in targets.indices {
            guard targets[index].hp > 0 else { continue }
            let targetPoint = CGPoint(x: targets[index].x * size.width, y: targets[index].y * size.height)
            let distance = hypot(point.x - targetPoint.x, point.y - targetPoint.y)
            if distance < 48 {
                targets[index].hp = max(0, targets[index].hp - weapon.damage)
                if targets[index].hp == 0 { score += 1 }
                hit = true
                break
            }
        }

        message = hit ? "TOUCHÉ" : "MANQUÉ"
        if targets.allSatisfy({ $0.hp == 0 }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                round += 1
                profile.credits += 500
                targets = [
                    .init(x: 0.22, y: 0.22, hp: min(200, 100 + round * 10)),
                    .init(x: 0.49, y: 0.32, hp: min(200, 100 + round * 10)),
                    .init(x: 0.79, y: 0.20, hp: min(200, 100 + round * 10)),
                    .init(x: 0.67, y: 0.52, hp: min(200, 100 + round * 10))
                ]
                buyPhase = true
                message = "PHASE D'ACHAT"
            }
        }
    }
}

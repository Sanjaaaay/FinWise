import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 64, weight: .bold))
                .foregroundStyle(Color(hex: 0x052224))
            Text("FinWise")
                .font(.fw(34, .bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: 0x00D09E).ignoresSafeArea())
        .task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            withAnimation(.easeInOut(duration: 0.3)) {
                app.showLaunch = false
            }
        }
    }
}

#Preview {
    LaunchView().environmentObject(AppState())
}

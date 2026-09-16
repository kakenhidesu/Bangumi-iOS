import SwiftUI

struct BootstrapLoadingView: View {
  var body: some View {
    VStack {
      Spacer()
      Image(systemName: "waveform")
        .resizable()
        .scaledToFit()
        .frame(width: 72, height: 72)
        .variableColorSymbolEffectIfAvailable()
      Spacer()
    }
    .padding(24)
  }
}

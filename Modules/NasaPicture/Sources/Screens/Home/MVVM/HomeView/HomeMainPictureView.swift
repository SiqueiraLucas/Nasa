import SwiftUI

struct HomeMainPictureView: View {
    let horizontalPadding: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Título da seção
            Text("Foto do dia")
                .font(.title.weight(.semibold))
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)
            
            // Placeholder da imagem
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(16/9, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, horizontalPadding)
        }
    }
}

#Preview {
    HomeMainPictureView(horizontalPadding: 24)
}

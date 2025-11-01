import SwiftUI

struct HomeGridSectionView: View {
    let horizontalPadding: CGFloat
    private let otherCount = 12
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Outras fotos")
                .font(.title2.weight(.semibold))
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(0..<otherCount, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 160)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    HomeGridSectionView(
        horizontalPadding: 24
    )
}

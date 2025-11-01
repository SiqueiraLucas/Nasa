import SwiftUI

struct HomeHeaderView: View {
    let title: String
    let date: String
    let horizontalPadding: CGFloat
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.largeTitle.bold())
            
            Spacer()
            
            Button(action: {
                print("Botão pressionado")
            }) {
                Text(date)
                    .font(.callout.bold())
                    .padding(.top, 4)
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    HomeHeaderView(
        title: "Title",
        date: "01/01/2025",
        horizontalPadding: 24
    )
}

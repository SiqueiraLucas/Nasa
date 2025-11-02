import SwiftUI

struct HomeHeaderView: View {
    let data: HomeData.Header
    let horizontalPadding: CGFloat
    
    var body: some View {
        HStack(alignment: .center) {
            Text(data.title)
                .font(.largeTitle.bold())
            
            Spacer()
            
            Button(action: {
                print("Botão pressionado")
            }) {
                HStack(spacing: 6) {
                    Text(data.date)
                        .font(.callout.bold())

                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.callout)
                }
                .padding(.top, 4)
            }

        }
        .padding(.top, 16)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    HomeHeaderView(
        data: HomeData.Header(
            title: "Title",
            date: "01/01/2025"),
        horizontalPadding: 24
    )
}

import SwiftUI

struct HomeHeaderView: View {
    let header: HomeModel.HeaderData
    let horizontalPadding: CGFloat
    let touchDateButton: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text(header.title)
                .font(.largeTitle.bold())
            
            Spacer()
            
            Button(action: {
                touchDateButton()
            }) {
                HStack(spacing: 6) {
                    Text(header.date)
                        .font(.callout.bold())

                    Image(systemName: "line.3.horizontal.decrease")
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
        header: HomeModel.HeaderData(
            date: "01/01/2025"
        ),
        horizontalPadding: 24) {
            print("touchDateButton")
        }
}

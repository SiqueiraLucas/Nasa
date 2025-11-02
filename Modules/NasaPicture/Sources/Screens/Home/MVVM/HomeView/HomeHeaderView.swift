import SwiftUI

struct HomeHeaderView: View {
    let title: String
    let date: String
    let horizontalPadding: CGFloat
    let touchDateButton: () -> Void
    
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.largeTitle.bold())
            
            Spacer()
            
            Button(action: {
                touchDateButton()
            }) {
                HStack(spacing: 6) {
                    Text(date)
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
        title: "Title",
        date: "01/01/2025",
        horizontalPadding: 24) {
            print("touchDateButton")
        }
}

import SwiftUI

public struct ErrorData {
    public let title: String
    public let description: String
    public let buttonTitle: String?
    public let buttonAction: (() -> Void)?
}

public struct ErrorView: View {
    public let data: ErrorData
    private let horizontalPadding = CGFloat(24)
    
    public init(data: Any) {
        self.data = data as? ErrorData ?? ErrorData(title: "", description: "", buttonTitle: "", buttonAction: nil)
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text(data.title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            
            Text(data.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if let buttonTitle = data.buttonTitle, let buttonAction = data.buttonAction {
                Button(action: buttonAction) {
                    Text(buttonTitle)
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorView(
        data: ErrorData(
            title: "Oops!",
            description: "Something went wrong.",
            buttonTitle: "Try again",
            buttonAction: { print("Try again tapped.") }
        )
    )
}

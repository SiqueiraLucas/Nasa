import SwiftUI

public struct URLImage: View {
    public let url: URL
    public let cornerRadius: CGFloat
    @State private var loadedImage: UIImage?
    @State private var isLoading = false
    
    public var body: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
            }
        }
        .onAppear(perform: loadImage)
    }
    
    private func loadImage() {
        guard !isLoading else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.loadedImage = uiImage
                }
            }
        }.resume()
    }
}

import SwiftUI

public struct URLImage: View {
    public let url: URL
    public let cornerRadius: CGFloat
    public var enableFullScreen: Bool = false
    public var customTap: (() -> Void)? = nil

    @State private var loadedImage: UIImage?
    @State private var isLoading = false
    @State private var showFullScreen = false

    private static var imageCache = NSCache<NSURL, UIImage>()

    public var body: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .onTapGesture {
                        if enableFullScreen {
                            showFullScreen = true
                        }
                        customTap?()
                    }
                    .fullScreenCover(isPresented: $showFullScreen) {
                        if let uiImage = loadedImage {
                            FullScreenImageView(image: uiImage, isPresented: $showFullScreen)
                        }
                    }
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

        if let cachedImage = Self.imageCache.object(forKey: url as NSURL) {
            self.loadedImage = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    Self.imageCache.setObject(uiImage, forKey: url as NSURL)
                    self.loadedImage = uiImage
                }
            }
        }.resume()
    }
}

public extension URLImage {
    func onCustomTap(_ customTap: @escaping () -> Void) -> URLImage {
        var copy = self
        copy.customTap = customTap
        return copy
    }

    func onFullScreenTap(_ enabled: Bool = true) -> URLImage {
        var copy = self
        copy.enableFullScreen = enabled
        return copy
    }
}

struct FullScreenImageView: View {
    let image: UIImage
    @Binding var isPresented: Bool

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .offset(offset)
                .scaleEffect(scale)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value
                            }
                            .onEnded { _ in
                                lastScale = scale
                            },
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(width: lastOffset.width + value.translation.width,
                                                height: lastOffset.height + value.translation.height)
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                )

            Button(action: { isPresented = false }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

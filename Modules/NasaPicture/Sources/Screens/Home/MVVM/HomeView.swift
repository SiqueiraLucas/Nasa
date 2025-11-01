import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let horizontalPadding: CGFloat = 24
    
    // Quantidade de placeholders
    let favoriteCount = 5
    let otherCount = 12
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Header
                HStack(alignment: .center) {
                    Text(viewModel.model.title)
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    Button(action: {
                        print("Botão pressionado")
                    }) {
                        Text(viewModel.model.date)
                            .font(.callout.bold())
                            .padding(.top, 4)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, horizontalPadding)

                // MARK: - Divider
                Divider()
                    .background(Color.gray)
                    .padding(.horizontal, horizontalPadding)

                // MARK: - Título Foto do dia
                Text("Foto do dia")
                    .font(.title.weight(.semibold))
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 8)
                
                // MARK: - Foto do dia (placeholder)
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, horizontalPadding)
                
                // MARK: - Favoritos
                
                HStack(alignment: .center) {
                    Text("Favoritos")
                        .font(.title2.weight(.semibold))
                    
                    Spacer()
                    
                    Button(action: {
                        print("Botão pressionado")
                    }) {
                        Text("Ver todos")
                            .font(.footnote.bold())
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, horizontalPadding)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<favoriteCount, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 120)
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                
                // MARK: - Outras fotos (grade)
                
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
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            Task {
                await viewModel.fetch()
            }
        }
    }
}

#Preview {
//    HomeView()
}

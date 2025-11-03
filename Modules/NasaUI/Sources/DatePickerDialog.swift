import SwiftUI

public struct DatePickerDialog: View {
    public let minimumDate: Date
    public let maximumDate: Date
    public var currentDate: Date
    public var onDateSelected: (Date) -> Void
    @Binding public var isPresented: Bool

    @State private var selectedDate: Date

    public init(minimumDate: Date,
         maximumDate: Date,
         currentDate: Date,
         isPresented: Binding<Bool>,
         onDateSelected: @escaping (Date) -> Void) {
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.currentDate = currentDate
        self._isPresented = isPresented
        self.onDateSelected = onDateSelected
        _selectedDate = State(initialValue: currentDate)
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 16) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: minimumDate...maximumDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()

                Button(action: {
                    isPresented = false
                    onDateSelected(selectedDate)
                }) {
                    Text("Concluir")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom)
                .padding(.horizontal, 24)
            }
            .frame(height: 360)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal)
            .transition(.move(edge: .bottom))
            .animation(.easeInOut, value: isPresented)
        }
    }
}

struct DatePickerDialog_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        DatePickerDialog(
            minimumDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
            maximumDate: Date(),
            currentDate: Date(),
            isPresented: $isPresented
        ) { newDate in
            print("Data selecionada: \(newDate)")
        }
    }
}

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MealsViewModel()
    @State private var showingAddMeal = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фон
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    // Кнопка "Прийом їжі" (автоматично ставить поточний час)
                    Button(action: {
                        showingAddMeal = true
                    }) {
                        Text("Прийом їжі")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()

                    // Список
                    MealListView(viewModel: viewModel)
                }
                .navigationBarTitle("Мій трекер їжі", displayMode: .inline)
            }
            .sheet(isPresented: $showingAddMeal) {
                // Коли відкривається sheet, створюємо новий Meal з датою "зараз"
                AddMealView(viewModel: viewModel,
                            initialDate: Date()) // передаємо поточний час
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}

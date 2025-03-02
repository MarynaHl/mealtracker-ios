import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MealsViewModel()
    @State private var showingAddMeal = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Кнопка "Add Meal"
                Button(action: {
                    showingAddMeal = true
                }) {
                    Text("Add Meal")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .sheet(isPresented: $showingAddMeal) {
                    AddMealView(viewModel: viewModel)
                }
                
                // Список прийомів їжі
                MealListView(viewModel: viewModel)
            }
            .navigationTitle("Meal Tracker")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

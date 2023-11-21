//
//  ConfigurationsView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct ConfigurationsView: View {

    @ObservedObject var algorithm: Algorithm

    @Binding var showSettings: Bool

    var body: some View {
        VStack {
            Button {
                withAnimation {
                    showSettings.toggle()
                }
            } label: {
                Text(showSettings ? "Hide settings" : "Show settings")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            if showSettings {
                VStack {
                    customSection(header: "Configurations", content: AnyView(customTwoCells))
                    customSection(header: "Current state", content: AnyView(customCell))
                }.padding([.top, .bottom])
            }
        }.background(Color(uiColor: .secondarySystemBackground))
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CoreDataFetcher.shared.fetchEntities(
        ofType: Algorithm.self,
        withPredicate: nil,
        in: context
    )[0]
    return ConfigurationsView(algorithm: algorithm, showSettings: .constant(true))
        .environment(\.managedObjectContext, context)
}

extension ConfigurationsView {
    private func customSection(header: String = "", content: AnyView) -> some View {
        VStack(spacing: 6) {
            customHeaderView(header)
            content
        }
    }

    private var customCell: some View {
        let text = "State \(0)"
        return ConfigurationButton(text: text) {
            
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var customTwoCells: some View {
        VStack(alignment: .leading, spacing: 7) {
            ConfigurationButton(text: "Tapes") {
                
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 5)

            Divider()
                .padding(.leading)

            ConfigurationButton(text: "States") {
                
            }
            .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private func customHeaderView(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
    }
}

struct ConfigurationButton: View {

    let text: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .font(.footnote)
        }.padding(.horizontal)
    }
}


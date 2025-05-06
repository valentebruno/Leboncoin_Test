//  ListingRowView.swift
//  lebocoin
//  Created by Bruno Valente on 06/05/25.
import SwiftUI

struct ListingRowView: View {
    let item: ListingItem
    let categoryName: String?

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: item.imagesUrl.thumb ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 100)


            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(2)
                    Spacer()
                    if item.isUrgent {
                        Text("URGENT")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.orange.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                
                Text(categoryName ?? "N/A")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(String(format: "%.2f €", item.price))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.vertical, 8)
    }
}


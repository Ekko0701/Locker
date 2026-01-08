import SwiftUI
import Locker

struct UserDefaultsView: View {
    @StateObject private var viewModel = UserDefaultsViewModel()
    @State private var searchKey: String = ""
    @State private var showingDeleteAllAlert = false
    @State private var showingSearchResult = false
    
    var body: some View {
        NavigationView {
            Form {
                // 검색 섹션
                Section(header: Text("특정 값 조회")) {
                    HStack {
                        TextField("Key 입력", text: $searchKey)
                            .autocapitalization(.none)
                        
                        Button("조회") {
                            viewModel.searchKey(searchKey)
                            showingSearchResult = true
                        }
                        .disabled(searchKey.isEmpty)
                    }
                    
                    if showingSearchResult, let result = viewModel.searchResult {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("결과:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(result)
                                .font(.body)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                
                // 전체 조회 섹션
                Section(header: Text("저장된 키 목록 (\(viewModel.userDefaultsKeys.count)개)")) {
                    if viewModel.userDefaultsKeys.isEmpty {
                        Text("저장된 데이터가 없습니다")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(viewModel.userDefaultsKeys, id: \.self) { key in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(key)
                                        .font(.body)
                                    if let value = viewModel.getValue(for: key) {
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                
                                Spacer()
                                
                                // 개별 삭제 버튼
                                Button(action: {
                                    viewModel.deleteKey(key)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }
                
                // 선택 삭제 섹션
                if !viewModel.userDefaultsKeys.isEmpty {
                    Section(header: Text("선택 삭제")) {
                        Button(action: {
                            viewModel.toggleSelectionMode()
                        }) {
                            HStack {
                                Image(systemName: viewModel.isSelectionMode ? "checkmark.circle.fill" : "checkmark.circle")
                                Text(viewModel.isSelectionMode ? "선택 모드 종료" : "선택 모드 시작")
                            }
                        }
                        
                        if viewModel.isSelectionMode {
                            ForEach(viewModel.userDefaultsKeys, id: \.self) { key in
                                Button(action: {
                                    viewModel.toggleSelection(key)
                                }) {
                                    HStack {
                                        Image(systemName: viewModel.selectedKeys.contains(key) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(viewModel.selectedKeys.contains(key) ? .blue : .gray)
                                        Text(key)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                            }
                            
                            if !viewModel.selectedKeys.isEmpty {
                                Button(action: {
                                    viewModel.deleteSelectedKeys()
                                }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                        Text("선택한 \(viewModel.selectedKeys.count)개 삭제")
                                    }
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                }
                
                // 전체 삭제
                if !viewModel.userDefaultsKeys.isEmpty {
                    Section {
                        Button(action: {
                            showingDeleteAllAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("전체 삭제")
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                
                if let message = viewModel.statusMessage {
                    Section {
                        Text(message)
                            .font(.callout)
                            .foregroundColor(viewModel.isSuccess ? .green : .red)
                    }
                }
            }
            .navigationTitle("UserDefaults 관리")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.refreshKeys()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .alert("전체 삭제", isPresented: $showingDeleteAllAlert) {
                Button("취소", role: .cancel) { }
                Button("삭제", role: .destructive) {
                    viewModel.deleteAll()
                }
            } message: {
                Text("UserDefaults에 저장된 모든 데이터를 삭제하시겠습니까?")
            }
            .onAppear {
                viewModel.refreshKeys()
            }
        }
    }
}

#Preview {
    UserDefaultsView()
}


//
//  SearchViewController.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import UIKit
import Combine

final class SearchViewController: BaseViewController {    
    private lazy var viewModel: SearchImageContainerViewModel = SearchImageContainerViewModel(serviceProvider: serviceProvider ?? ServiceProvider())
    
    @IBOutlet weak var imageListTableView: UITableView!
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "이미지 검색"
        searchController.searchBar.setValue("취소", forKey:"cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
          
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviUI()
        bind()
    }

    private func setNaviUI() {
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bind() {
        viewModel.$imageInfoList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in //sink : sink를 통해 publisher에 대한 subscription을 작성
                self?.imageListTableView.reloadData()
            })
            .store(in: &bag) //store: //Stores this type-erasing cancellable instance in the specified set
                             //Cancellable instance를 저장
        
        searchController.searchBar.searchTextField.textPublisher
            .debounce(for: 0.7, scheduler: RunLoop.main)
            .removeDuplicates() // 중복호출 제거
            .sink { [weak viewModel] in
                viewModel?.searchImageList(term: $0)
            }
            .store(in: &bag)
        
        //에러, 상태 체크
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .loading:
                    //loading event
                    break
                case .finishedLoading:
                    //finishedLoading event
                    break
                case .error(let error):
                    self?.showError(error)
                case .dataEnd:
                    break
                }
            })
            .store(in: &bag)
    }  
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imageInfoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setData(model: viewModel.imageInfoList?[safe: indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = viewModel.imageInfoList?[safe: indexPath.row],
              let width = model.width,
              let height = model.height else { return 0 }
        
        return viewModel.calculateRatio(imageSize: CGSize(width: width, height: height), screenSize: UIScreen.main.bounds.size)
    }
     
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.checkLoadMoreData(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = getViewController(ImageDetailViewController.self) as? ImageDetailViewController else {
            fatalError("ImageDetailViewController none")
        }
        
        viewController.setViewModel(viewModel: viewModel, currentIndex: indexPath.row)
        viewController.returnHandler = { [weak self] index in
            self?.imageListTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: false)
        }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: {})
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchImageList(term: "")
    }
}

//
//  ViewController.swift
//  List Photo
//
//  Created by KhuePM on 10/4/25.
//

import UIKit

class PhotoListViewController: UIViewController {

    private let viewModel: PhotosViewModel
    private let refreshControl = UIRefreshControl()
    private let searchBar = UISearchBar()
    let debouncer = Debouncer(delay: 0.4)

    init(viewModel: PhotosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSearchBar() {
        searchBar.placeholder = "Search by author or id"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        edgesForExtendedLayout = [.top, .bottom, .left, .right]
        extendedLayoutIncludesOpaqueBars = true
        setupSearchBar()
        setupTableView()
        bindViewModel()
        viewModel.loadInitialPhotos()
        setupRefreshControl()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        tableView.separatorStyle = .none

        view.addSubview(tableView)

        view.addSubview(loadingLabel)
        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func bindViewModel() {

    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func didPullToRefresh() {
        viewModel.loadInitialPhotos()
    }

}

extension PhotoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = viewModel.filteredPhotos.isEmpty ? viewModel.photos : viewModel.filteredPhotos
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UITableViewCell()
        }
        let data = viewModel.filteredPhotos.isEmpty ? viewModel.photos : viewModel.filteredPhotos
        let photo = data[indexPath.row]
        cell.configure(with: photo)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 2 {
            viewModel.loadMorePhotos()
        }
    }
}

extension PhotoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.run {
            let sanitized = SearchValidator.sanitizeInput(searchText)

            if sanitized != searchText {
                searchBar.text = sanitized
            }

            if sanitized.isEmpty {
                self.viewModel.resetSearch()
            } else {
                self.viewModel.search(query: sanitized)
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension PhotoListViewController: PhotosViewModelDelegate {

    func didLoadInitialPhotos() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    func didLoadMorePhotos(newIndexPaths: [IndexPath]) {
        tableView.insertRows(at: newIndexPaths, with: .fade)
    }

    func didChangeLoadingState(isLoading: Bool) {
        loadingLabel.isHidden = !isLoading
        if isLoading {
            loadingLabel.text = "loading..."
        } else {
            loadingLabel.text = ""
        }
    }

    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

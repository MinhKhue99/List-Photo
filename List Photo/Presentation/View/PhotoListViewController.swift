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
    private var isSearchCancelled = false

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
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }

    private var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

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
        edgesForExtendedLayout = [.top, .bottom, .left, .right]
        extendedLayoutIncludesOpaqueBars = true

        configureNavigationBar()
        setupSearchBar()
        setupTableView()
        setupEmptyStateLabel()
        setupRefreshControl()

        viewModel.loadInitialPhotos()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        view.addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupEmptyStateLabel() {
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func updateEmptyStateVisibility() {
        let data = viewModel.isSearching ? viewModel.filteredPhotos : viewModel.photos
        emptyStateLabel.isHidden = !data.isEmpty
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func didPullToRefresh() {
        searchBar.resignFirstResponder()
        viewModel.loadInitialPhotos()
    }

    func configureNavigationBar() {
        if #available(iOS 13.0, *) {
            // iOS 13+: Use UINavigationBarAppearance for light/dark mode
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground // Adapts to light/dark mode
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

            // Apply to all navigation bar states
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance

            // Set tint color for buttons
            navigationController?.navigationBar.tintColor = .systemBlue
        } else {
            // iOS 12: Fallback to classic UINavigationBar properties
            navigationController?.navigationBar.barStyle = .default // Light mode style
            navigationController?.navigationBar.barTintColor = .white // Background color
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.tintColor = .blue // Button tint
            navigationController?.navigationBar.isTranslucent = false // Opaque background
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension PhotoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = viewModel.isSearching ? viewModel.filteredPhotos : viewModel.photos
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UITableViewCell()
        }
        let data = viewModel.isSearching ? viewModel.filteredPhotos : viewModel.photos
        let photo = data[indexPath.row]
        cell.configure(with: photo)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        guard !viewModel.isLoading else { return }
        if offsetY > contentHeight - frameHeight * 2 {
            viewModel.loadMorePhotos()
        }
    }
}

// MARK: - UISearchBarDelegate

extension PhotoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.cancel()
        debouncer.run { [weak self] in
            guard let self = self else { return }

            if self.isSearchCancelled {
                self.isSearchCancelled = false
                return
            }

            let sanitized = SearchValidator.sanitizeInput(searchText)

            if sanitized != searchText {
                DispatchQueue.main.async {
                    searchBar.text = sanitized
                }
            }

            if !sanitized.isEmpty {
                self.viewModel.search(query: sanitized)
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchCancelled = true
        debouncer.cancel()
        searchBar.resignFirstResponder()
        searchBar.text = nil
        viewModel.resetSearch()
    }
}

// MARK: - PhotosViewModelDelegate

extension PhotoListViewController: PhotosViewModelDelegate {

    func didLoadInitialPhotos() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.updateEmptyStateVisibility()
        }
    }

    func didLoadMorePhotos(newIndexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateEmptyStateVisibility()
        }
    }

    func didChangeLoadingState(isLoading: Bool) {
        DispatchQueue.main.async {
            self.loadingLabel.isHidden = !isLoading
            self.loadingLabel.text = isLoading ? "Loading..." : ""
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

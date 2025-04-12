//
//  PhotosViewModel.swift
//  List Photo
//
//  Created by KhuePM on 12/4/25.
//

import Foundation

protocol PhotosViewModelDelegate: AnyObject {
    func didLoadInitialPhotos()
    func didLoadMorePhotos(newIndexPaths: [IndexPath])
    func didChangeLoadingState(isLoading: Bool)
    func didFailWithError(_ error: Error)
}

class PhotosViewModel {
    private let getPhotosUseCase: GetPhotosUseCase

    init(getPhotosUseCase: GetPhotosUseCase) {
        self.getPhotosUseCase = getPhotosUseCase
    }

    private(set) var photos: [Photo] = []
    private(set) var filteredPhotos: [Photo] = []
    private var currentPage = 1
    private let limit = 100
    private var _isLoading = false {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.didChangeLoadingState(isLoading: self._isLoading)
            }
        }
    }
    var isLoading: Bool {
        return _isLoading
    }

    weak var delegate: PhotosViewModelDelegate?

    func loadInitialPhotos() {
        guard !_isLoading else { return }
        _isLoading = true
        delegate?.didChangeLoadingState(isLoading: true)
        currentPage = 1

        getPhotosUseCase.execute(page: currentPage, limit: limit) { [weak self] result in

            guard let self = self else { return }
            _isLoading = false

            switch result {
            case .success(let photos):
                self.photos = photos
                Logger.shared.debugPrint("Photo count: \(photos.count)", function: "loadInitialPhotos")
                DispatchQueue.main.async { [self] in
                    self.delegate?.didLoadInitialPhotos()
                    self.delegate?.didChangeLoadingState(isLoading: false)
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                    self.delegate?.didChangeLoadingState(isLoading: false)
                }
            }
        }
    }

    func loadMorePhotos() {
        guard !_isLoading else {
            Logger.shared.debugPrint("Skipping loadMorePhotos: already loading", function: "loadMorePhotos")
            return
        }
        _isLoading = true
        delegate?.didChangeLoadingState(isLoading: true)
        currentPage += 1

        getPhotosUseCase.execute(page: currentPage, limit: limit) { [weak self] result in
            guard let self = self else { return }
            self._isLoading = false

            switch result {
            case .success(let newPhotos):
                Logger.shared.debugPrint("Photo count: \(newPhotos.count)", function: "loadMorePhotos")
                let startIndex = self.photos.count
                self.photos.append(contentsOf: newPhotos)
                let endIndex = self.photos.count
                let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                DispatchQueue.main.async {
                    self.delegate?.didLoadMorePhotos(newIndexPaths: indexPaths)
                    self.delegate?.didChangeLoadingState(isLoading: false)
                }
            case .failure(let error):
                Logger.shared.debugPrint("error: \(error.localizedDescription)", function: "loadMorePhotos")
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                    self.delegate?.didChangeLoadingState(isLoading: false)
                }
            }
        }
    }

    func search(query: String) {
        let cleanedText = SearchValidator.sanitizeInput(query)
        guard !cleanedText.isEmpty else {
            filteredPhotos = []
            DispatchQueue.main.async {
                self.delegate?.didFailWithError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid search query"]))
                self.delegate?.didChangeLoadingState(isLoading: false)
            }
            return
        }
        guard !_isLoading else { return }
        _isLoading = true
        self.delegate?.didChangeLoadingState(isLoading: true)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let filtered = photos.filter { photo in
                photo.author.lowercased().contains(query.lowercased()) ||
                photo.id.lowercased().contains(query.lowercased())
            }

            DispatchQueue.main.async {
                self.filteredPhotos = filtered
                self.delegate?.didLoadInitialPhotos()
                self.delegate?.didChangeLoadingState(isLoading: false)
                self._isLoading = false
            }
        }
    }

    func resetSearch() {
        filteredPhotos = []
        DispatchQueue.main.async {
            self.delegate?.didLoadInitialPhotos()
        }
    }
}

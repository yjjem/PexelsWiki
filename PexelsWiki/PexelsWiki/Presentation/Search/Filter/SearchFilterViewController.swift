//
//  SearchFilterView.swift
//  PexelsWiki
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

protocol SearchFilterViewControllerDelegate {
    func didApplyFilterOptions(_ options: FilterOptions)
}

final class SearchFilterViewController: UIViewController {
    
    private let searchFilterTableView: UITableView = {
        let collection = UITableView(frame: .zero, style: .insetGrouped)
        return collection
    }()
    
    var viewModel: SearchFilterViewModel?
    var delegate: SearchFilterViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        
        configureNavigationItem()
        configureSearchFilterTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }
        
        let selectedOrientationIndex = viewModel.selectedOrientation.orderIndex
        preselectOptionAt(section: .orientation, row: selectedOrientationIndex)
        
        let selectedSizeIndex = viewModel.selectedSize.orderIndex
        preselectOptionAt(section: .size, row: selectedSizeIndex)
        
    }
    
    private func preselectOptionAt(section: Section, row: Int) {
        let indexPath = IndexPath(row: row, section: section.sectionOrderIndex)
        searchFilterTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    
    @objc func didTapDoneButton() {
        if let viewModel {
            let options = FilterOptions(
                orientation: viewModel.selectedOrientation,
                size: viewModel.selectedSize
            )
            delegate?.didApplyFilterOptions(options)
        }
        
        dismiss(animated: true)
    }
    
    private func configureNavigationItem() {
        let confirmButtonItem = UIBarButtonItem(
            title: "Apply Filter",
            style: .plain,
            target: self,
            action: #selector(didTapDoneButton)
        )
        navigationItem.title = "Search Filter"
        navigationItem.rightBarButtonItem = confirmButtonItem
    }
    
    private func configureSearchFilterTableView() {
        addSearchFilterTableView()
        searchFilterTableView.allowsMultipleSelection = true
        searchFilterTableView.dataSource = self
        searchFilterTableView.delegate = self
        searchFilterTableView.register(
            SearchFilterOptionCell.self,
            forCellReuseIdentifier: SearchFilterOptionCell.reuseIdentifier
        )
    }
    
    private func addSearchFilterTableView() {
        view.addSubview(searchFilterTableView)
        
        searchFilterTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchFilterTableView.topAnchor.constraint(equalTo: view.topAnchor),
            searchFilterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchFilterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchFilterTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchFilterViewController: UITableViewDelegate {
    
    func uncheckPreviousCells(in tableView: UITableView, _ indexPath: IndexPath) {
        let currentSection = indexPath.section
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        if selectedIndexPaths.contains(indexPath) {
            return
        }
        
        selectedIndexPaths
            .filter { $0.section == currentSection }
            .forEach { tableView.deselectRow(at: $0, animated: true) }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        uncheckPreviousCells(in: tableView, indexPath)
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        let sections = Section.allCases
        
        switch sections[sectionIndex] {
        case .orientation:
            viewModel?.selectedOrientation = ContentOrientation.allCases[rowIndex]
        case .size:
            viewModel?.selectedSize = ContentSize.allCases[rowIndex]
        }
    }
}

extension SearchFilterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchFilterOptionCell.reuseIdentifier,
            for: indexPath
        ) as! SearchFilterOptionCell
        
        var configuration = cell.defaultContentConfiguration()
        configuration.prefersSideBySideTextAndSecondaryText = true
        configuration.text = Section.allCases[indexPath.section].optionsNames[indexPath.row]
        cell.contentConfiguration = configuration
        
        return cell
    }
}

extension SearchFilterViewController {
    
    enum Section: CaseIterable {
        case orientation
        case size
        
        var sectionName: String {
            switch self {
            case .orientation: return "Orientation"
            case .size: return "Size"
            }
        }
        
        var numberOfRows: Int {
            switch self {
            case .orientation: return ContentOrientation.allCases.count
            case .size: return ContentSize.allCases.count
            }
        }
        
        var optionsNames: [String] {
            switch self {
            case .orientation: return ContentOrientation.allCases.map { $0.name }
            case .size: return ContentSize.allCases.map { $0.name }
            }
        }
        
        var sectionOrderIndex: Int {
            switch self {
            case .orientation: return 0
            case .size: return 1
            }
        }
    }
}


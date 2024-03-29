//
//  ServantTableViewController.swift
//  FateIndex+
//
//  Created by 管君 on 9/26/18.
//  Copyright © 2018 管君. All rights reserved.
//

import UIKit

class ServantTableViewController: UITableViewController {

    private struct Constants {
        static let defaultCellHeight: CGFloat = 78.0

        static let servantClasses: [String] = [
            "saber", "archer", "lancer", "rider",
            "caster", "assassin", "berserker", "shielder",
            "ruler", "avenger", "moonCancer", "alterego",
            "foreigner"
        ]

        static let placeHolder = "搜索从者"
        static let idName = "编号"
        static let atkDesc = "ATK降序"
        static let hpDesc = "HP降序"
    }

    private let searchController = UISearchController(searchResultsController: nil)

    private var servants = [Servant]()

    private lazy var servantsDict = {
        return Dictionary(grouping: servants, by: { $0.servant.clazz })
    }()

    private var filteredServants = [Servant]()

    let mailboxChooserSidePickerTransition = SidePickerTransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(AvatarWithTextTableViewCell.self, forCellReuseIdentifier: AvatarWithTextTableViewCell.identifier)
        tableView.register(TableViewTitleHeaderView.self, forHeaderFooterViewReuseIdentifier: TableViewTitleHeaderView.identifier)

        setupSearchViewController()
        servants = ServantManager.shared.allServants { [weak self] servants in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }

                strongSelf.servants.append(contentsOf: servants)
                strongSelf.servantsDict = Dictionary(grouping: strongSelf.servants, by: { $0.servant.clazz })
                strongSelf.tableView.reloadData()
            }
        }

        view.addGestureRecognizer(mailboxChooserSidePickerTransition.presentationPanGestureRecognizer)
        mailboxChooserSidePickerTransition.delegate = self
        mailboxChooserSidePickerTransition.presentationPanGestureRecognizer.delegate = self
    }

    // MARK:- UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering() ? 1 : Constants.servantClasses.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredServants.count
        }
        else {
            let servantClass = Constants.servantClasses[section]
            return servantsDict[servantClass]?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AvatarWithTextTableViewCell.identifier, for: indexPath) as! AvatarWithTextTableViewCell

        cell.accessoryType = .disclosureIndicator

        if isFiltering() {
            cell.avatar = UIImage(named: "Servant_\(filteredServants[indexPath.row].servant.no)")
            cell.title = filteredServants[indexPath.row].servant.name
            return cell
        }
        else {
            let servantClass = Constants.servantClasses[indexPath.section]
            if let servants = servantsDict[servantClass] {
                cell.avatar = UIImage(named: "Servant_\(servants[indexPath.row].servant.no)")
                cell.title = servants[indexPath.row].servant.name
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultCellHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isFiltering() {
            return nil
        }

        let servantClass = Constants.servantClasses[section]
        if let hasServant = servantsDict[servantClass], hasServant.isEmpty {
            return nil
        }

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewTitleHeaderView.identifier) as! TableViewTitleHeaderView

        headerView.title = servantClass
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37.5
    }

    // MARK:- UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            let vc = ServantDetailTableViewController(servant: filteredServants[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let servantClass = Constants.servantClasses[indexPath.section]

            if let servants = servantsDict[servantClass] {
                let vc = ServantDetailTableViewController(servant: servants[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    private func setupSearchViewController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.placeHolder
        searchController.searchBar.delegate = self

        searchController.searchBar.scopeButtonTitles = [
            Constants.idName, Constants.atkDesc, Constants.hpDesc
        ]
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension ServantTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let text = searchController.searchBar.text, let scopeButtonTitles = searchBar.scopeButtonTitles {
            let scope = scopeButtonTitles[searchBar.selectedScopeButtonIndex]
            filterContentForSearchText(text, scope: scope)
        }
    }

    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private func filterContentForSearchText(_ searchText: String, scope: String = Constants.idName) {
        filteredServants = servants.filter { servant in
            if searchText == "" {
                return true
            }
            return servant.servant.name.lowercased().contains(searchText.lowercased())
        }.sorted {
            return sortHelper(lhs: $0, rhs: $1, scope: scope)
        }

        tableView.reloadData()
    }

    private func sortHelper(lhs: Servant, rhs: Servant, scope: String) -> Bool {
        switch scope {
        case Constants.idName:
            return lhs.servant.no < rhs.servant.no
        case Constants.atkDesc:
            return lhs.status[0].atk > rhs.status[0].atk
        case Constants.hpDesc:
            return lhs.status[0].hp > rhs.status[0].hp
        default:
            return lhs.servant.no < rhs.servant.no
        }
    }

    private func isFiltering() -> Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }

}

extension ServantTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if let text = searchBar.text, let scopeButtonTitles = searchBar.scopeButtonTitles {
            filterContentForSearchText(text, scope: scopeButtonTitles[selectedScope])
        }

        searchBar.resignFirstResponder()
    }

}

extension ServantTableViewController: SidePickerTransitionDelegate {
    func presentedViewControllerForSidePickerTransition(_ sidePickerTransition: SidePickerTransition) -> UIViewController? {
        return LeftNavPanningVC()
    }

    func sidePickerPresentViewController(_ presentedViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        present(presentedViewController, animated: animated, completion: completion)
    }

    func sidePickerTransition(_ sidePickerTransition: SidePickerTransition, didPerformTransition transitionEvent: SidePickerTransitionEvent) {

    }
}

extension ServantTableViewController: UIGestureRecognizerDelegate {

}

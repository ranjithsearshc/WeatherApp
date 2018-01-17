//
//  searchTableViewController.swift
//  WeatherApp
//
//  Created by Ranjith  on 1/17/18.
//  Copyright (c) . All rights reserved.
//

import UIKit

let cellIdentifier = "basicCell"
class searchTableViewController: UITableViewController,UISearchResultsUpdating {

    let unfilteredCityNames = WAUserUtils.cityNamesList
    var filteredCityNames: [String]?
    let searchController = UISearchController(searchResultsController: nil)
    weak var delegate:ReceiveData! //send the data back to DataviewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpViewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    //MARK: setup viewdata
    func setUpViewData() {
        filteredCityNames = unfilteredCityNames
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: TableDataSource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nflTeams = filteredCityNames else {
            return 0
        }
        return nflTeams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let nflTeams = filteredCityNames {
            let team = nflTeams[indexPath.row]
            cell.textLabel!.text = team
        }
        
        return cell
    }
    
    //MARK: TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = filteredCityNames {
            let cityName = filteredCityNames![indexPath.row]
            saveAndSendDataToController(cityName)
        }
    }
    
    
    // MARK:UISearchResultsUpdating Methods
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredCityNames = unfilteredCityNames.filter { team in
                return team.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredCityNames = unfilteredCityNames
        }
        tableView.reloadData()
    }
    
    //MARK: Save and sent to dataviewController
    func saveAndSendDataToController(_ cityName:String) {
        WAUser.shared.defaultCity = cityName
        delegate.dataReceive(cityName)
        self.dismiss(animated: true, completion: nil)
    }


}

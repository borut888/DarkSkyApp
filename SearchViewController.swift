//
//  SearchVC.swift
//  DarkSkyApp
//
//  Created by Borut on 19/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit
import CoreLocation
import QuartzCore
import Moya

let providerCities = MoyaProvider<SearchAPI>()
protocol SearchControllerDataDelegate: class {
    func sendLatLong(lat: String, long: String)
    func sendString(data: String, intForAlpha: CGFloat, boolShowSearchBar: Bool)
    func sendBlurStatus(intForAlpha: CGFloat)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableViewCities: UITableView!
    var listOfCitiesObjects = [CityNames]()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    weak var delegate:SearchControllerDataDelegate?
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        tableViewCities.backgroundColor = .clear
        tableViewCities.separatorStyle = .none
        searchView.layer.cornerRadius = searchView.frame.size.width / 19
        searchView.clipsToBounds = true
        txtSearch.setLeftPaddingPoints(20)
        txtSearch.becomeFirstResponder()
        
    }
    @IBAction func btnSearchPressed(_ sender: Any) {
        let urlCity = txtSearch.text
        activityIndicator.startAnimating()
        downloadCities(city: urlCity!)
        
    }
    //MARK: parsing data for tableView
    func downloadCities(city: String) {
        providerCities.request(SearchAPI.cities(cityName: city, maxRows: cityDataAPI.numberOfRows, apiKey: cityDataAPI.apyKey)) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let citiesDowload = try decoder.decode(SearchModel.self, from: response.data)
                    self.listOfCitiesObjects = citiesDowload.geonames
                    DispatchQueue.main.async {
                        self.tableViewCities.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                    
                }catch let err  {
                    print(" there is some error: \(err)" )
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        delegate?.sendBlurStatus(intForAlpha: 0.0)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: extension for tableView
extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCitiesObjects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCities.dequeueReusableCell(withIdentifier: "customCell") as! CitiesTableViewCell
        let cities = listOfCitiesObjects[indexPath.row].name
        cell.lblCityName.text = cities
        if let firstLetter = txtSearch.text?.first{
            cell.lblFirstLetter.text = "\(firstLetter)"
        }
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewCities.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let citiesSelected = listOfCitiesObjects[indexPath.row]
        delegate?.sendString(data: citiesSelected.name, intForAlpha: 0.0, boolShowSearchBar: false)
        delegate?.sendLatLong(lat: citiesSelected.lat, long: citiesSelected.lng)
        CoreDataHandler.saveObject(cityName: citiesSelected.name, lat: citiesSelected.lat, long: citiesSelected.lng)
        dismiss(animated: true, completion: nil)
    }
}

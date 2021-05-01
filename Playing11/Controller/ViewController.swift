//
//  ViewController.swift
//  Playing11
//
//  Created by SAGAR THAKARE on 29/04/21.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController {
    
    //MARK:- Outlet's
    @IBOutlet weak var tblPlayerListing: UITableView!
    
    //MARK:- Variables
    //  1. Pakistan Team Info
    var pakTeamObject               : Teams?
    var arrPakistanPlayerList       = [Players]()
    //  2. South Africa Team Info
    var saTeamsObject               : Teams?
    var arrSouthAfricaPlayerList    = [Players]()
    //  3. Constraint's
    var leadingConstraints          :NSLayoutConstraint?
    var trailingConstraints         :NSLayoutConstraint?
    //  4. isTeam Selection
    var isTeamPresent               = false
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ConfigurationUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPlayersDetails()
    }
    
    //MARK:- Configuration of UI
    func ConfigurationUI() {
        
        self.tableviewConfiguration()
        self.view.addSubview(stackView)
        self.stackView.addArrangedSubview(segmentPakistanBtn)
        self.stackView.addArrangedSubview(segmentSouthAfricaBtn)
        self.view.addSubview(pagerView)
        self.view.addSubview(activityIndicationView)
        self.constraints()
        self.segmentButtonUI()
        self.title = "Playing 11"
    }
    
    //MARK:- Segmented Button View
    //  1. Segenment Button for Pakistan
    var segmentPakistanBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Pakistan", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    //  2. Segenment Button for South Africa
    var segmentSouthAfricaBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("South Africa", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    //  3. Stack View for Adding Button's
    var stackView: UIStackView = {
        
        let stackView           = UIStackView()
        stackView.axis          = .horizontal
        stackView.alignment     = .fill
        stackView.distribution  = .fillEqually
        stackView.spacing       = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    //  4. Pager View for Animation of Changing Button Action
    var pagerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    //  5. UIView Constraint's
    func constraints() {
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        segmentPakistanBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        pagerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true
        pagerView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        pagerView.widthAnchor.constraint(equalTo: segmentPakistanBtn.widthAnchor, multiplier: 1.0, constant: 0).isActive = true
        leadingConstraints = pagerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leadingConstraints?.isActive = true
        trailingConstraints = pagerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: segmentSouthAfricaBtn.frame.width)
        trailingConstraints?.isActive = true
        trailingConstraints?.priority = UILayoutPriority(rawValue: 250)
        
        activityIndicationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicationView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    //  6. Segment Button UI
    func segmentButtonUI() {
        segmentPakistanBtn.addTarget(self, action: #selector(onPressSegmentPakistanBtn(_:)), for: .touchUpInside)
        segmentSouthAfricaBtn.addTarget(self, action: #selector(onPressSegmentSouthAfricaBtn(_:)), for: .touchUpInside)
    }
    //  7. Activity Indicator View
    lazy var activityIndicationView: UIActivityIndicatorView = {
        let activityIndicationView = UIActivityIndicatorView(style: .medium)
        activityIndicationView.color = .white
        activityIndicationView.backgroundColor = .darkGray
        activityIndicationView.layer.cornerRadius = 5.0
        activityIndicationView.hidesWhenStopped = true
        activityIndicationView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicationView
    }()
    //  8. Start Loading Indicator View
    func startLoading(tblView: UITableView) {
        tblView.isUserInteractionEnabled = false
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    //  9. Stop Loading Indicator View
    func stopLoading(tblView: UITableView) {
        DispatchQueue.main.async {
            tblView.isUserInteractionEnabled = true
            self.activityIndicationView.stopAnimating()
            self.activityIndicationView.isHidden = true
        }
    }
    
    //MARK:- Setting Up Data
    //  1. TableView Configuration
    func tableviewConfiguration() {
        
        self.tblPlayerListing.register(UINib(nibName: TableViewCellIdentifire.kPlayerDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifire.kPlayerDetailsTableViewCell)
        
        self.tblPlayerListing.dataSource     = self
        self.tblPlayerListing.delegate       = self
        self.tblPlayerListing.separatorStyle = .none
    }
    
    //  2. Function for Getting Playing 11 Details
    func getPlayersDetails() {
        
        self.startLoading(tblView: self.tblPlayerListing)
        self.loadJson(fromURLString: BaseURL.playingTeam1) { (result) in
            switch result {
            case .success(let data):
                self.stopLoading(tblView: self.tblPlayerListing)
                self.parse(jsonData: data)
            case .failure(let error):
                self.stopLoading(tblView: self.tblPlayerListing)
                print(error)
            }
        }
    }
    
    //  3. Load JSON from URL String
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    //  4. Parsing Data into Codable Model
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Playing11Model.self,
                                                       from: jsonData)
            let pakTeam = decodedData.Teams?.teams?.last
            self.pakTeamObject = pakTeam
            print(pakTeam?.Name_Full ?? "")
            self.arrPakistanPlayerList = pakTeam?.Players?.players ?? []
            
            let saTeam = decodedData.Teams?.teams?.first
            self.saTeamsObject = saTeam
            print(saTeam?.Name_Full ?? "")
            self.arrSouthAfricaPlayerList = saTeam?.Players?.players ?? []
            
            DispatchQueue.main.async {
                self.tblPlayerListing.reloadData()
            }
        } catch {
            print("decode error")
        }
    }
    
    //MARK:- All Button Action's
    //  1. Pakistan
    @objc func onPressSegmentPakistanBtn(_ sender: UIButton) {
        self.isTeamPresent = false
        tblPlayerListing.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.leadingConstraints?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    //  2. South Africa
    @objc func onPressSegmentSouthAfricaBtn(_ sender: UIButton) {
        self.isTeamPresent = true
        tblPlayerListing.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.leadingConstraints?.constant = self.segmentPakistanBtn.frame.width
            self.trailingConstraints?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}


//MARK:- TableView DataSource & Delegate
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isTeamPresent == false {
            return self.arrPakistanPlayerList.count
        } else {
            return self.arrSouthAfricaPlayerList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPlayerListing.dequeueReusableCell(withIdentifier:
                                                            TableViewCellIdentifire.kPlayerDetailsTableViewCell, for: indexPath) as! PlayerDetailsTableViewCell
        
        if self.isTeamPresent == false {
            let data = self.arrPakistanPlayerList[indexPath.row]
            if data.Iscaptain == true &&  data.Iskeeper == true {
                cell.lblPlayerFullName.text = "\(data.Name_Full ?? "" ) (c) (wc)"
                
            } else if data.Iscaptain == true {
                cell.lblPlayerFullName.text = "\(data.Name_Full ?? "") (c)"
            } else if data.Iskeeper == true {
                cell.lblPlayerFullName.text = "\(data.Name_Full ?? "") (wc)"
            } else {
                cell.lblPlayerFullName.text = "\(data.Name_Full ?? "")"
            }
        }
        else {
            let data = self.arrSouthAfricaPlayerList[indexPath.row]
            if data.Iscaptain == true &&  data.Iskeeper == true {
                cell.lblPlayerFullName.text = "\(data.Name_Full ?? "" ) (c) (wc)"
                
            } else if data.Iscaptain == true {
                cell.lblPlayerFullName.text = "\(data.Name_Full ?? "") (c)"
            } else if data.Iskeeper == true {
                cell.lblPlayerFullName.text = "\(data.Name_Full ?? "") (wc)"
            } else {
                cell.lblPlayerFullName.text = "\(data.Name_Full ?? "")"
            }
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
}

//
//  RecentlyPlayedVC.swift
//  Radio Player
//
//  Created by Chandresh Kachariya on 10/07/21.
//

import UIKit

class RecentlyPlayedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /***************IBOutlet*****************/
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewBottomConstraint: NSLayoutConstraint!
    /***************Variables*****************/
    private var viewModel = SearchViewModel()
    private let reuseIdentifier = "PlayerViewTVCell"
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
        requestRecentPlayerResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Use this code to manage the bottom view of the player
        if PlayerVC.shared.strPlayedUrl != "" {
            tblViewBottomConstraint.constant = -100
        }else {
            tblViewBottomConstraint.constant = 0
        }
    }
    
    //Use this method for default initialization
    func initSetup() {
        ///Setup Tableview
        tblView.estimatedRowHeight = 44
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tblView.tableFooterView = UIView.init()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblView.addSubview(refreshControl)
    }
}

//MARK:- UITableView delegate datasource methods
extension RecentlyPlayedVC {
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        requestRecentPlayerResults()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.RecentPlayerList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PlayerViewTVCell
        cell.setupData(dictPlayer: viewModel.RecentPlayerList![indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Load Player view at bottom
        tblViewBottomConstraint.constant = -100
        PlayerVC.shared.dictPlayer = viewModel.RecentPlayerList![indexPath.row]
        PlayerVC.shared.setupData()
        PlayerVC.shared.strPlayedUrl = "https://rfcmedia.streamguys1.com/70hits.aac"
        PlayerVC.shared.setupUrl()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- API Methods
extension RecentlyPlayedVC {
    //Use this method for call api
    private func requestRecentPlayerResults() {
        viewModel.fetchRecentPlayerResults(apikey: "testapi") { status in
            DispatchQueue.main.async { [self] in
                self.refreshControl.endRefreshing()
                switch status {
                case Key.API.status.success.rawValue:
                    print("Success")
                    print("Total search:- \(viewModel.RecentPlayerList?.count ?? 0)")
                    
                    self.tblView.reloadData()
                    
                case Key.API.status.unauthorized.rawValue:
                    print("Unauthorized")
                default:
                    print(status)
                }
            }
        } failure: { (error) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                print("Data not found")
            }
            print(error)
        }
    }
}

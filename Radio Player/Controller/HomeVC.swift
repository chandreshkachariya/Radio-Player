//
//  HomeVC.swift
//  Radio Player
//
//  Created by Chandresh Kachariya on 10/07/21.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /***************IBOutlet*****************/
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tblViewBottomConstraint: NSLayoutConstraint!
    /***************Google Ads*****************/
    private var BANNER_ADS_ID = "ca-app-pub-3940256099942544/2934735716"
    /***************Variables*****************/
    private var viewModel = SearchViewModel()
    private let reuseIdentifier = "PlayerViewTVCell"
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()        
        requestPlayerResults()
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
        /// Setup Ads
        bannerView.adUnitID = BANNER_ADS_ID
        bannerView.rootViewController = self
        loadBannerAd()
    }
}

// MARK: - Google Ads Methods
extension HomeVC {
    //Use this method for load banner ads
    private func loadBannerAd() {
      // Here safe area is taken into account, hence the view frame is used after the
      // view has been laid out.
      let frame = { () -> CGRect in
        if #available(iOS 11.0, *) {
          return view.frame.inset(by: view.safeAreaInsets)
        } else {
          return view.frame
        }
      }()
      let viewWidth = frame.size.width

      // Here the current interface orientation is used. If the ad is being preloaded
      // for a future orientation change or different orientation, the function for the
      // relevant orientation should be used.
      bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
      bannerView.load(GADRequest())
    }
}

// MARK: - UITableView delegate datasource methods
extension HomeVC {
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        requestPlayerResults()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.PlayerList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PlayerViewTVCell
        cell.setupData(dictPlayer: viewModel.PlayerList![indexPath.row])
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Load Player view at bottom
        tblViewBottomConstraint.constant = -100
        PlayerVC.shared.dictPlayer = viewModel.PlayerList![indexPath.row]
        PlayerVC.shared.setupData()
        PlayerVC.shared.strPlayedUrl = "https://rfcmedia.streamguys1.com/70hits.aac"
        PlayerVC.shared.setupUrl()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - API Methods
extension HomeVC {
    //Use this method for call api
    private func requestPlayerResults() {
        viewModel.fetchPlayerResults(apikey: "testapi") { status in
            self.refreshControl.endRefreshing()
            switch status {
            case Key.API.status.success.rawValue:
                DispatchQueue.main.async { [self] in
                    print("Success")
                    print("Total search:- \(viewModel.PlayerList?.count ?? 0)")
                    self.tblView.reloadData()
                }
            case Key.API.status.unauthorized.rawValue:
                print("Unauthorized")
            default:
                print(status)
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

// MARK: - Banner delegate methods
extension HomeVC: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: 0)
        bannerView.transform = translateTransform

        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Fail to receive ads")
        print(error)
    }
}

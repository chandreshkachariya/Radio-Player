//
//  PlayerVC.swift
//  Radio Player
//
//  Created by Chandresh Kachariya on 10/07/21.
//

import UIKit
import MediaPlayer
import FRadioPlayer

class PlayerVC: UIViewController {
    
    /***************Singleton ref to player*****************/
    static let shared = PlayerVC.init(nibName: "PlayerVC", bundle: nil)
    /***************IBOutlet*****************/
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imgPlayer: UIImageView!
    /***************Variables*****************/
    // Singleton ref to player
    public let player: FRadioPlayer = FRadioPlayer.shared
    public var dictPlayer: PlayerModel?
    public var strPlayedUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
        setupRemoteTransportControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUrl()
        if dictPlayer != nil {
            setupData()
        }
    }
 
    //Use this method for default initialization
    private func initSetup() {
        // Set the delegate for the radio player
        player.httpHeaderFields = ["user-agent": "FRadioPlayer"]
        player.delegate = self
    }

    public func setupUrl() {
        self.view.isHidden = false
        player.radioURL = URL.init(string: strPlayedUrl)
    }
    
    public func setupData() {
        imgPlayer.getImage(url: self.dictPlayer?.image_url ?? "", placeholderImage: UIImage.init(named: "radio")) { success in
            self.imgPlayer.contentMode = .scaleAspectFill
        } failer: { failed in
            self.imgPlayer.contentMode = .scaleAspectFit
        }
        lblName.text = self.dictPlayer?.name
        lblArtist.text = dictPlayer?.artist
        lblAlbum.text = dictPlayer?.album
    }
}

// MARK: - IBAction Methods
extension PlayerVC {
    @IBAction func btnPlay(_ sender: Any) {
        if btnPlay.isSelected {
            player.pause()
            btnPlay.isSelected = false
        }else {
            player.togglePlaying()
            btnPlay.isSelected = true
        }
    }
}

// MARK: - FRadioPlayerDelegate
extension PlayerVC: FRadioPlayerDelegate {
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print("playerStateDidChange: \(state.description)")
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        self.btnPlay.isSelected = player.isPlaying
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        //track = Track(artist: artistName, name: trackName)
    }
    
    func radioPlayer(_ player: FRadioPlayer, itemDidChange url: URL?) {
        //track = nil
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange rawValue: String?) {
        //infoContainer.isHidden = (rawValue == nil)
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        
        // Please note that the following example is for demonstration purposes only, consider using asynchronous network calls to set the image from a URL.
    }
}

// MARK: - Remote Controls / Lock screen
extension PlayerVC {
    private func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Next Command
        commandCenter.nextTrackCommand.addTarget { event in
            //self.next()
            return .success
        }
        
        // Add handler for Previous Command
        commandCenter.previousTrackCommand.addTarget { event in
            //self.previous()
            return .success
        }
    }
}

// MARK: - UINavigationController

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

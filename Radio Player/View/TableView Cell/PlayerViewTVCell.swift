//
//  PlayerViewTVCell.swift
//  Radio Player
//
//  Created by Chandresh Kachariya on 10/07/21.
//

import UIKit
import SDWebImage

class PlayerViewTVCell: UITableViewCell {

    /***************UIImageView*****************/
    @IBOutlet weak var imgPlayer: UIImageView!
    
    /***************UILabel*****************/
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!

    /***************UIButton*****************/
    @IBOutlet weak var btnPlay: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(dictPlayer: PlayerModel) {
        imgPlayer.getImage(url: dictPlayer.image_url ?? "", placeholderImage: UIImage.init(named: "radio")) { success in
            self.imgPlayer.contentMode = .scaleAspectFill
        } failer: { failed in
            self.imgPlayer.contentMode = .scaleAspectFit
        }

        lblName.text = dictPlayer.name
        lblArtist.text = dictPlayer.artist
        lblAlbum.text = dictPlayer.album
    }
}


extension UIImageView {
    
    func getImage(url: String, placeholderImage:  UIImage?,
                  success:@escaping (_ _result : Any? ) -> Void,
                  failer:@escaping (_ _result : Any? ) -> Void) {
        
        self.sd_setImage(with: URL(string: url), placeholderImage:  placeholderImage, options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            // your rest code
            if error == nil {
                self.image = image
                success(true)
            }else {
                failer(false)
            }
        })
        
    }
}

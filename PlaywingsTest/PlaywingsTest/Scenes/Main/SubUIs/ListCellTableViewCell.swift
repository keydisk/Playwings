//
//  ListCellTableViewCell.swift
//  PlaywingsTest
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit
import SwiftyJSON

/// ListCell
class ListCellTableViewCell: UITableViewCell {

    /// 컨텐츠 내용 표시
    @IBOutlet weak var contentsLabel: UILabel!
    /// 타이틀 라벨
    @IBOutlet weak var titleLabel: UILabel!
    /// 음료 이미지
    @IBOutlet weak var introBrewImg: UIImageView!
    
    /// 이미지 높이
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    /// 이미지 로딩 완료를 알려주기 위한 콜백 메소드
    var loadingComplete:(() -> Void)?
    
    private var _tag: Int = 0
    override var tag: Int {
        get {
            
            return self._tag
        }
        set {
            
            self._tag = newValue
            
            self.contentsLabel.numberOfLines = 0
            if let name = BrewListData.shared.getName(newValue) {
                
                self.titleLabel.text = name
            }
            else {
                
                self.titleLabel.text = ""
            }
            
            if let description = BrewListData.shared.getDescription(newValue) {
                
                self.contentsLabel.text = description
                
                if let brewersTips = BrewListData.shared.getTip(newValue) {
                    
                    let attributedString = NSMutableAttributedString(string:description );
                    
                    let attrebuteFirst  = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 19.0), NSForegroundColorAttributeName : UIColor.RGBA(0x23, 0x23, 0x23)];
                    
                    self.contentsLabel.text?.append("\n\n tips : \(brewersTips)")
                    attributedString.addAttributes(attrebuteFirst, range:(attributedString.string as NSString).range(of: brewersTips))
                    
                    self.contentsLabel.attributedText = attributedString;
                }
            }
            else {
                
                self.contentsLabel.text = ""
            }
            
            if let imgUrlText = BrewListData.shared.getImgUrl(newValue) {
                
                self.introBrewImg.loadingImgFromUrl(imgUrlText, {() in
                    
                    if let tmpImg = self.introBrewImg.image {
                        
                        let oringRate   = tmpImg.size.width / tmpImg.size.height
                        
                        self.introBrewImg.image = self.introBrewImg.image?.resizedImage(CGSize(width: self.introBrewImg.frame.size.width, height: self.introBrewImg.frame.size.width / oringRate))
                    }
                })
            }
            else {
                
                self.introBrewImg.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    }
    
}

//
//  SGFloatVideoView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/31.
//

import UIKit
import AVFoundation

class SGFloatVideoView: UIView {
    
    let width: CGFloat = 70
    let height: CGFloat = 120
    
    private lazy var closeButton: UIButton = self.createCloseButton()
    private lazy var player: AVPlayer = self.createAVPlayer()
    private lazy var playerLayer: AVPlayerLayer = self.createAVPlayerLayer()
    private lazy var playerItem: AVPlayerItem = self.createAVPlayerItem()
    
    var url: String!
    
    var closeClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x,
                                 y: frame.origin.y,
                                 width: width,
                                 height: height))
        _initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let y = touches.first?.location(in: superview).y ?? 0
        let startY = (height / 3)
        let endY = (height / 3) * 2
        if y >= startY && y <= endY {
            self.player.play()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let x = touches.first?.location(in: superview).x ?? 0
        let y = touches.first?.location(in: superview).y ?? 0
        self.frame = CGRect(x: x,
                            y: y,
                            width: width,
                            height: height)
        self.player.play()
    }

}

// MARK: - UI
extension SGFloatVideoView{
    
    fileprivate func _initView(){
        self.backgroundColor = .gray
        self.addSubview(closeButton)
        
        self.layer.addSublayer(playerLayer)
        
        _initData()
    }
    
    fileprivate func createCloseButton() -> UIButton{
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 0,
                              height: 0)
        button.addTarget(self, action: #selector(closeEvent), for: UIControl.Event.touchUpInside)
        return button
    }
    
}

// MARK: - Event.
extension SGFloatVideoView{
    
    @objc fileprivate func closeEvent(){
        if closeClosure != nil {
            closeClosure!()
        }
    }
    
    fileprivate func _initData(){
        closeClosure = {
            self.removeFromSuperview()
        }
    }
    
}

// MARK: - Video Layer.
extension SGFloatVideoView{
    
    fileprivate func createAVPlayerItem() -> AVPlayerItem{
        let item = AVPlayerItem(url: URL(string: "https://prod-streaming-video-msn-com.akamaized.net/b7014b7e-b38f-4a64-bd95-4a28a8ef6dee/113a2bf3-3a5f-45d4-8b6f-e40ce8559da3.mp4")!)
        return item
    }
    
    fileprivate func createAVPlayer() -> AVPlayer{
        let layer = AVPlayer(playerItem: playerItem)
        return layer
    }
    
    fileprivate func createAVPlayerLayer() -> AVPlayerLayer{
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return layer
    }
    
}

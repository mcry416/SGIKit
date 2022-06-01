//
//  SGFloatVideoView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/31.
//
import UIKit
import AVFoundation

class SGFloatVideoView: UIView {
    
    private let width: CGFloat = 70
    private let height: CGFloat = 120
    private let roundCorner: CGFloat = 5
    
    private var selfX: CGFloat = 0
    private var selfY: CGFloat = 0
    
    private lazy var closeButton: UIButton = self.createCloseButton()
    private lazy var player: AVPlayer = self.createAVPlayer()
    private lazy var playerLayer: AVPlayerLayer = self.createAVPlayerLayer()
    private lazy var playerItem: AVPlayerItem = self.createAVPlayerItem()
    
    private var url: String!
    
    private var isPlay: Bool = false
    
    private var timeObserver: Any!
    
    var closeClosure: (() -> Void)?
    var setOnProgressListener: ((_ rate: Float) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x,
                                 y: frame.origin.y,
                                 width: width,
                                 height: height))
        
    }
    
    convenience init(frame: CGRect, url: String) {
        self.init(frame: frame)
        self.url = url
        
        _initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.player.removeTimeObserver(timeObserver)
    }

}

// MARK: - Override Touch Event.
extension SGFloatVideoView{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selfX = touches.first?.location(in: self).x ?? 0
        selfY = touches.first?.location(in: self).y ?? 0
        
        if !isPlay {
            play()
        } else {
            pause()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let x = touches.first?.location(in: superview).x ?? 0
        let y = touches.first?.location(in: superview).y ?? 0
        self.frame = CGRect(x: x - selfX,
                            y: y - selfY,
                            width: width,
                            height: height)
    }
}

// MARK: - UI
extension SGFloatVideoView{
    
    fileprivate func _initView(){
        self.backgroundColor = .gray
        self.addSubview(closeButton)
        
        self.layer.cornerRadius = roundCorner
        self.layer.addSublayer(playerLayer)
        
        _initData()
        
    }
    
    fileprivate func createCloseButton() -> UIButton{
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: width - 20,
                              y: 0,
                              width: 20,
                              height: 20)
        button.setImage(UIImage(named: "sg_float_video_close"), for: .normal)
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
        addProgressListener()
    }
    
    public func play(){
        self.player.play()
        self.isPlay = true
    }
    
    public func pause(){
        self.player.pause()
        self.isPlay = false
    }
    
}

// MARK: - Video Layer.
extension SGFloatVideoView{
    
    fileprivate func createAVPlayerItem() -> AVPlayerItem{
        let item = AVPlayerItem(url: URL(string: url!)!)
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

// MARK: - Progress.
extension SGFloatVideoView{
    
    fileprivate func addProgressListener(){
        let progressObserver = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 30), queue: nil) { (cmtime) in
            let progress = (cmtime.seconds) / CMTimeGetSeconds(self.player.currentItem!.duration)
            let rate = Float(progress).roundTo(3)
            if self.setOnProgressListener != nil {
                self.setOnProgressListener!(rate)
            }
            Log.debug("Progress: \(rate)")
        }
        timeObserver = progressObserver
    }
    
}

extension Float{
    
    func roundTo(_ places: Int) -> Float{
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

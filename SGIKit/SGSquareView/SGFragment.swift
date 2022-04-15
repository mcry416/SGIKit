//
//  SGFragment.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/3/21.
//

import UIKit

class SGFragment: UIView, SGSquareDelegate{
    
    /**
     Data source for SGFragment.
     - Before set delegate or call method of updateFragment(), user ought to instantiate or cast the generic collection data source.
     - It's importance to call method of updateFragment() after call the variable.
     */
    public var datas: Array<Any>!
    
    private var _isScrollEnable: Bool = true
    /// Set SGFragment status of scroll.
    public var isScrollEnable: Bool{
        set{
            _isScrollEnable = newValue
            self.sgSquareView.isScrollEnable = _isScrollEnable
        }
        get{
            return _isScrollEnable
        }
    }
    
    private var _isTapToCenter: Bool = false
    /// Set tap action status for Lattice whether will move to center when user tap Lattice, default false.
    public var isTapToCenter: Bool{
        set{
            _isTapToCenter = newValue
            self.sgSquareView.isTapToCenter = _isTapToCenter
        }
        get{
            return _isTapToCenter
        }
    }
    
    private var _isPageEnable: Bool = true
    /// Decide to whether scroll SGSquareView has pageable ability.
    public var isPageEnable: Bool{
        set{
            _isPageEnable = newValue
            self.sgSquareView.isPageEnable = _isPageEnable
        }
        get{
            return _isPageEnable
        }
    }
    
    private var _cornerRadius: CGFloat = 0
    /// Set SGFragment corner radius. Default 0.
    public var cornerRadius: CGFloat {
        set{
            _cornerRadius = newValue
            self.layer.cornerRadius = _cornerRadius
        }
        get{
            return _cornerRadius
        }
    }
    
    private var _miniLatticeSpace: CGFloat = 10
    /// Minium Lattice space. Defalut 10.
    public var miniLatticeSpace: CGFloat{
        set{
            _miniLatticeSpace = newValue
            self.sgSquareView.miniLaticeSpace = _miniLatticeSpace
        }
        get{
            return _miniLatticeSpace
        }
    }
    
    private var _headOffset: CGFloat = 10
    /// Head Lattice offset with SGSqaureView. Defalut 0.
    public var headOffset: CGFloat {
        set{
            _headOffset = newValue
            self.sgSquareView.HEAD_OFFSET = _headOffset
        }
        get{
            return _headOffset
        }
    }
    
    /// Delegate for SGSquareView.
    public weak var delegate: SGSquareDelegate? {
        didSet{
            self.sgSquareView.delegate = delegate
        }
    }
    
    private lazy var sgSquareView: SGSquareView = {
        let view = SGSquareView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        view.isPageEnable = true
        // Hook life cycle method by closure.
        view.willReloadCompletion = { [weak self] in
            self?.willUpdateFragment()
        }
        view.didReloadCompletion = { [weak self] in
            self?.didUpdateFragment()
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(sgSquareView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Defalut override method.
     - Parameter bundle: A bundle means a series data or model to through ViewController deliver itself into Fragment by method of bindBundle. Any data use could transfer.
     */
    public func bindBundle(_ bundle: Any) {
        
    }
    
    /// Before update Fragment will execute this method.
    @objc public func willUpdateFragment(){
   
    }
    
    /// After update Fragment will execute this method.
    @objc public func didUpdateFragment(){

    }
    
    /// Update fragment data and view.
    public func updateFragment(animated: Bool){
        self.delegate = self
        self.sgSquareView.reload()
        
        if animated {
            // Set opening animation.
            self.sgSquareView.alpha = 0
            UIView.animate(withDuration: 2.8) {
                self.sgSquareView.alpha = 1
            }
        }
    }
    
    /**
     Set SGFrgament shadow with parameters.
     - Parameter color: Shadow color, UIColor.
     - Parameter opacity: Shadow opacity, Float.
     - Parameter radius: Shadow radius, CGFloat.
     - Parameter offset: Shadow offset, CGSize.
     */
    public func setFragmentShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
    }
    
}

// MARK: - SGSquareDelegate.
extension SGFragment{
    
    /**
     How many items need to show in SGSquareView.
     - When Fragment has been setted data source, which should not implements this method generally speaking.
     - When Fragment has been setted data source, which will return count of source for Fragment, this method will override old count of item for Fragment consequentlly.
     - Parameter sgSquareView: SGSquareView.
     - Returns: Int, count of items.
     */
    func numberOfItemForSGSquareView(_ sgSquareView: SGSquareView) -> Int {
        return datas.count
    }
    
    /**
     According to concrete index to return SGSqaureView instance.
     - Parameter sgSquareView: SGSquareView.
     - Returns: SGSquareViewLattice instance.
     */
    func sgSquareViewAtIndex(_ sgSquareView: SGSquareView, index: Int) -> SGSquareViewLattice {
        return SGSquareViewLattice()
    }
    
    /**
     Which item has been clicked at SGSquareView.
     - Parameter sgSquareView: SGSquareView.
     - Parameter index: The position of item at SGSquareView has been clicked.
     */
    func sgSquareViewClickedAtIndex(_ sgSquareView: SGSquareView, index: Int) {

    }
    
    /**
     Return a title view for SGSquareView, which could contanis basic or fully attributes of view variable.
     - Parameter sgSquareView: SGSquareView.
     - Returns: UIView for use to custome.
     */
    func titleForSGSquareView(_ sgSquareView: SGSquareView) -> String {
        return ""
    }
    
    /**
     Return a size attributes of CGSzie for title view.
     - Parameter sgSquareView: SGSquareView.
     - Returns: CGSzie for title view.
     */
    func titleSizeForSGSquareView(_ sgSquareView: SGSquareView) -> CGSize {
        return .zero
    }

    /**
     Return a size attributes of CGSize for title(UILabel)
     - Returns: CGSize for title.
     */
    func titleViewForSGSquareView(_ sgSquareView: SGSquareView) -> UIView {
        return UIView()
    }

    /**
     Return a footer view for SGSquareView.
     - Returns: UIView for use to custome at bottom of SGSquareView.
     */
    func titleViewSizeForSGSquareView(_ sgSquareView: SGSquareView) -> CGSize {
        return .zero
    }
    
}

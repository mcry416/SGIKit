# [![v4wP4x.png](https://s1.ax1x.com/2022/08/31/v4wP4x.png)](https://imgse.com/i/v4wP4x)
# SGIKit
Standard General Interface Kit. It contains useful extension and foundation subclass which made of delegate/inherit/singleston/adapter desigen pattern.
Standard General Interface Fast Kit. It's DSL development way which made of closure and extension by Swift language features.


|Base Name| Function / Features|
|-|-|
|SGSqaureView| A development forms|
|SGIKit(Basic widget & foudation)| Self define view subclass and extension|
|SGIFKit| DSL development forms|

## Standard General Interface Kit.

### Basic Application Development Framework (An efficient MVVM like architecture based on hash algorithm)

- ### SGItem (Boot view layer)

- ### Bundle (Boot model and closure layer)

- ### SGFragment (An abstract section to manage item)

- ### SGActivity (Top management container, container delegate)

### 1.Basic Widget

- #### SGButton

- #### SGImageView

- #### SGListView

- #### SGTableView

- #### SGMenuView

- #### SGFloatVideoView

- #### SGPopupView

- #### SGNavigationBar

- #### SGImage

- #### SGToast

### 2.Foundation Extension

- #### SGString

- #### Log

- #### HashKV

- #### CachePool

## Standard General Interface Fast Kit.

### Foudation Widget.

- #### VLayout

- #### HLayout

- #### Button

- #### ImageView

- #### TextView

- #### List

### DSL(Not all) Features.

- #### Bind Widget Attributes.


Example code:

- SGListView apply in normally operation.
```swift
let list = SGListView(direction: .vertical, cellClass: MyCell.self)
listView.frame = self.view.frame
listView.itemSize = CGSize(width: kSCREEN_WIDTH - 50, height: 100)
        
listView.setOnCellDataBindListener { cellClass, model, indexPath in
    let tempModel: Test1Model = model as! Test1Model
    let tempCell: MyCell = cellClass as! MyCell
            
    tempCell.label.text = tempModel.text1
    tempCell.label2.text = tempModel.text2
}
listView.setOnCellClickListnenr { cell, indexPath in

}

```

- SGFragment subclass in SGSquareView forms

```swift
import UIKit

class SecondFragment: SGFragment {

    var latticeListener: ((_ index: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initFragment()

        super.datas = Array<SecondModel>()

    }

    required init?(coder: NSCoder) {
        fatalError("error to init.")
    }

    override func bindBundle(_ bundle: Any) {
        super.datas = bundle as? Array<SecondModel>
        self.updateFragment(animated: true)
    }

}

extension SecondFragment{

    override func titleForSGSquareView(_ sgSquareView: SGSquareView) -> String {
        return "  Second"
    }

    override func sgSquareViewAtIndex(_ sgSquareView: SGSquareView, index: Int) -> SGSquareViewLattice {
        let lattice = SGSquareViewLattice()
        lattice.size = CGSize(width: 100, height: 100)
        let model = super.datas[index] as! SecondModel
        lattice.image.image = UIImage(named: model.imageName)
        return lattice
    }

    override func sgSquareViewClickedAtIndex(_ sgSquareView: SGSquareView, index: Int) {
        if self.latticeListener != nil {
            latticeListener!(index)
        }
    }

}

extension SecondFragment{

    fileprivate func initFragment(){
        self.layer.cornerRadius = 10
        self.miniLatticeSpace = 0
        self.backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.98, alpha: 1)
   //     self.isPageEnable = false
    }

}
```
 

- DSL apply in `viewDidLoad()`
```swift
        VLayout {
            [self.HLayout {
                [self.Button(text: "Beijing") {
                    self.toast("Beijing", location: .center)
                    Log.debug("Beijing")
                },
                 self.Button(text: "Nanjing", listener: {
                    self.toast("Nanjing", location: .center)
                    self.Bind(1001).image = UIImage(named: "ef")
                })]
            },
             self.HLayout {
                 [self.ImageView(name: "taylor", size: CGSize(width: 66, height: 66), bind: 1001),
                  self.ImageView(name: "ef"),
                  self.ImageView(name: "ef")
                 ]
             }]
        }
```

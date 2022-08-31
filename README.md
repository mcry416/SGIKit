# [![v4wP4x.png](https://s1.ax1x.com/2022/08/31/v4wP4x.png)](https://imgse.com/i/v4wP4x)
# SGIKit
Standard General Interface Kit. It contains useful extension and foundation subclass which made of delegate/inherit/singleston/adapter desigen pattern.
Standard General Interface Fast Kit. It's DSL development way which made of closure and extension by Swift language features.


|Base Name| Function / Features|
|-|-|
|SGLowCoupling| A development forms|
|SGIKit(Basic widget & foudation)| Self define view subclass and extension|
|SGIFKit| DSL development forms|

## Standard General Interface Kit.

What we contains in here:

### Basic Application Development Framework (An efficient MVVM like architecture based on hash algorithm)

- ### SGItem (Boot view layer)

- ### Bundle (Boot model and closure layer)

- ### SGFragment (An abstract section to manage items)

- ### SGActivity (Top management container, container delegate)

### 1.Basic Widget

- #### SGButton 
A beautiful button with convenience usage.

- #### SGImageView
A beautiful and sensitive image view to use.

- #### SGListView
Big size data stream to show business view, which is more easyily to use than `UICollectionView`, and abondoned delegate design pattern to use.

- #### SGTableView
Vertical data stream to show various business view, which is more easily to use than 'UITableView', and abondoned delegate design pattern to use.

- #### SGMenuView
A popup style view to show an operation whether should be clicked, some operations form a menu.

- #### SGFloatVideoView
A float view that could be draged anywhere in view to presented a video.

- #### SGPopupView
A container to presented some widgets to popup.

- #### SGNavigationBar
A navigation bar to use in top of the view, which is beautiful and easy to use(really easy to use).

- #### SGSettingsView
A build pattern to generate three style settings view.

- #### SGGoodsView
A build pattern to generate a collection view that containes image view only.

- #### SGImage
An extension for UIImage.

- #### SGToast
A toast to show in the UIViewController.

### 2.Foundation Extension

- #### SGString
An extension for String.

- #### Log
A simplt log class to test in various class.

- #### HashKV
A simply K-V runtime cache class in application life cycle.

- #### CachePool
A cache class in application that initlized with various data structure.

- #### Memory
A tool to print the information for varible's ref or deliver value.

- #### GramKit (Developing.)
A tool like SnapKit for UIView and its subclass to make layout, notice its function to make layout rather than make constrains.

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

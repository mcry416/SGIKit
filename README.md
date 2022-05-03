# SGIKit
Standard General Interface Kit. It contains useful extension and foundation subclass which made of delegate/inherit/singleston/adapter desigen pattern.
Standard General Interface Fast Kit. It's DSL development way which made of closure and extension by Swift language features.


|Base Name| Function / Features|
|-|-|
|SGSqaureView| A development forms|
|SGIKit(Basic widget & foudation)| Self define view subclass and extension|
|SGIFKit| DSL development forms|

## Standard General Interface Kit.

### Basic Application Development Framework

- ### SGSquareViewLattice

- ### SGSquareView

- ### SGFragment

### 1.Basic Widget

- #### SGButton

- #### SGImageView

- #### SGListView

- #### SGTableView

- #### SGNavigationBar

- #### SGImage

- #### SGToast

### 2.Foundation Extension

- #### SGString

- #### Log

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

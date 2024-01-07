# [![v4wP4x.png](https://s1.ax1x.com/2022/08/31/v4wP4x.png)](https://imgse.com/i/v4wP4x)
# SGIKit
Standard General Interface Kit. It contains useful extension and foundation subclass which made of delegate/inherit/sington/adapter desigen pattern.
Standard General Interface Fast Kit. It's DSL development way which made of closure and extension by Swift language features.(Deprecated)


|Base Name| Function / Features|
|-|-|
|GSLowCoupling| A development forms|
|SGIKit(Basic widget & foudation)| Self define view subclass and extension|
|SGIFKit(Deprecated)| DSL development forms|

## Standard General Interface Kit.

What we contains in here:

### Basic Application Development Framework (An efficient MVVM like architecture based on hash algorithm)

- ### GSItem (Boot view layer)

- ### GSBundle (Boot model and closure layer)

- ### GSActivity (Top management container)

### 1.Basic Widget

- #### SGButton 
A beautiful button with convenience usage.

- #### SGImageView
A beautiful and sensitive image view to use.

- #### SGExcelView
A collection view(Its looks like Excel rather than `UICollectionView`) to present via datas.

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

- #### SGPopupSelectView
A popup style for select business scenes, fill some models only.

- #### SGPopupCenterView
A popup style container to add others sub-view.

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

- #### SGRichText
A chain called method to generate `NSAttributedString`.

### 2.UIKit/Foundation Extension

- #### UIImageView+Extension
Provide convenience way to set image with URL for UIImageView, whichs use `LRU` algorithm to make sure memory normally.

- #### UIView+Extension
Use runtime to add a convenience click listener with method.

- #### GCD+Extension
Provide an ability of operating queue, thread safety.

- #### String+Extension
An extension for String, likes text height or width, string cut.

- #### Log
A simply log class to test in various class.

- #### HashKV
A simply K-V runtime cache class in application life cycle, which could make thread safety.

- #### CachePool
A cache class in application that initlized with various data structure.

- #### Memory
A tool to print the information for varible's ref or deliver value.

- #### Gram
A tool like SnapKit for UIView to make layout with the DSL way.

- #### OS
Provide an ability to control boot system visited. eg. `pthread_lock`, `OSAtomicIncreasement`, etc.

Example code:

- Gram apply in layout:
```swift
imageView.gram.layout { make in
    make.size.equalTo(CGSize(width: 50, height: 50))
    make.centerX.equalTo(view.gram.centerX, offset: 100)
    make.centerY.equalTo(view.gram.centerY)
}
```

- Print a warning class infomation:
```swift
Log.warning(progress)
```

- Fastly to generate a settings view:
```swift
let view = SGSettingsView()
            .fill("WiFi", type: .done, res: nil)
            .fill("BlueTooth", type: .done, res: nil)
            .fill("Fly Mode", type: .done, res: nil)
            .builder()

view.setOnSettingsClickListener { [weak self] (index, status) in
    // print...
}
```

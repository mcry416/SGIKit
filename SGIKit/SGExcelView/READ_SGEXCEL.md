#  SGExcel

## Preview


## How to use
```
let row: SGExcelRow = SGExcelRow()
row.addBody(t1, t2, t3)
//        row.addBody(name, address, country)
//        let row1: SGExcelRow = SGExcelRow()
//        row1.addBody("Jack", "York", "England")
//        let row2: SGExcelRow = SGExcelRow()
//        row2.addBody("Bob", "Boston", "USA")
excelView = SGExcelView(frame: CGRect(x: 40, y: 100, width: self.view.frame.width - 80, height: self.view.frame.height - 230))
excelView.layer.cornerRadius = 15
excelView.rowHeight = 35
excelView.excelType = .readWrite

excelView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
excelView.addRow(row)
         .builder()
         .setOnExcelCellClickListener { row, column in
            Log.debug("row:\(row), column:\(column)")
         }
         .setOnExcelDidEditListener { content, row, column in
            Log.debug("content: \(content), row: \(row), column: \(column)")
         }
self.view.addSubview(excelView)

```

## Features


## Biasc Framework


### Swift 3での変更点

##### インクリメントの削除
```Swift
// before
self.page ++
// after
self.page += 1
```

##### 名称，文法の変更
| Before | After |
|:-------|:------|
| ErrorType | ErrorProtocol |
| NSxxx | xxx |
| NSUTF8StringEncoding | String.Encoding.utf8 |
| prepareForSegue(segue: | prepare(for segue: |

##### 第1引数名の明示
```Swift
// before
getValue(JSON, key: "score")
// after
getValue(JSON: JSON, key: "score")
```

##### 引数のvarの削除
```Swift
//　(廃止)値渡し
let failure = { (task: URLSessionDataTask!, var error: NSError!) -> Void in ...
//　const渡し
let failure = { (task: URLSessionDataTask!, error: NSError!) -> Void in ...
//　参照渡し
let failure = { (task: URLSessionDataTask!, inout error: NSError!) -> Void in ...
```

# Card

思路：参照着 UITableView 定义方法与属性，使用 pan 手势进行卡片的移动与旋转计算

1、CardViewItem 类似于 UITableViewCell，在一个 CardView 中可以有多种 item。可复用，提供 xib、class 两种方式向 CarView 注册；
2、卡片滑动支持两种 mode：remove、delete
    remove  左滑移出屏幕，右滑还原
    delete  左滑、右滑都是删除

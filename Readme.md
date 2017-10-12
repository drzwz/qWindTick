# qWindTick

  Wind DataFeed for kdb+tick

## 功能

  通过qWind/windkdb+接口订阅Wind实时行情，将行情发送到kdb+tick，供各类客户端订阅使用。

## 用法

1、下载qWindTick相关文件；下载kdb+，将q.k和q.exe放到指定文件夹下。

2、根据需要修改.\q\windmd.q里的拟订阅行情的证券代码。

3、运行qwindtibk.bat。

4、q或其它客户端向tickerplant订阅行情（详见kdb+tick：<http://code.kx.com/q/tutorials/startingq/tick/>）

## 注：对qWindTick的kdb+tick作了一些修改，主要包括日期改用time，收盘改为16:00等。

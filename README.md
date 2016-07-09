# 520Linkee
本项目比较完备的实现了作为一个直播App的基本功能，比如本地视频流采集、播放、美颜、礼物、点赞出心等。

![Linkee.10](http://upload-images.jianshu.io/upload_images/2004362-acd9765f38aa69b7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**美颜功能**使用的是BeautifyFace，本框架可以很快速的实现美颜功能，效果不错，它的底层还是基于的GPUImage，对GPUImage十分喜爱的Developer，可以参照BeautifyFace，写出一个属于自己的美颜功能，并且添加各种滤镜。


**播放端**播放端用的针对RTMP优化过的ijkplayer（下面提供下载地址），ijkplayer是基于FFmpeg的跨平台播放器，这个开源项目已经被多个 App 使用，其中映客、美拍和斗鱼使用了 ijkplayer（目前GitHub5700+⭐️） 。在本文的末未提供了，已经打包好的ijkplayer，直接拖入项目就可以使用。省去了编译的过程（编译十分麻烦，并且容易出错）。

**推流端**使用的是LFLiveKit，推流端可以选择很多GitHub上的开源项目替代LFLiveKit，比如VideoCore,和LiveVideoCoreSDK。商用的话可以选择各大厂商的SDK，网易直播云、七牛、腾讯、百度、新浪、其中金山直播云本人用过。使用直播云的好处就是能快速上线App，功能十分齐全，可以播放器和推流端，服务器一套下来，有专业客服人员帮助集成到工程中，缺点就是流量费太贵了，具体可以了解下各大厂商的收费标准。


[你想要的IJKMediaFramework.framework](http://pan.baidu.com/s/1eSLRmme)

- **使用方法：**把以上两个项目下载后，打开520Linkee会有报错（**报缺少IJKMediaFramework.framework的错误**），解压IJKMediaFramework.framework.zip后直接拖进工程运行即可。


- **ijk播放端的代码(点赞出心、礼物)：**Class/Live/Controller/PlayViewController

- **采集端代码（美颜、摄像头获取和切换）**：Class/Camera/View/StartLiveView

- **推流服务器设置:**Class/Camera/View/StartLiveView最后一个代码块，建议搭建**自己的服务器**[Mac搭建nginx+rtmp服务器](http://www.jianshu.com/p/02222073b3f1)

- **备用服务器地址（亲测可用）：**
- rtmp://live.hkstv.hk.lxdns.com:1935/live/stream123
- rtmp://live.hkstv.hk.lxdns.com:1935/live/hks
（将hks名称改成其他的，比如aaa）
- rtmp://202.69.69.180:443/live/aaa 
 (rtmp://202.69.69.180:443/webcast/bshdlive-pc)
- rtmp://v1.one-tv.com:1935/live/aaa
(rtmp://v1.one-tv.com:1935/live/mpegts.stream)
- rtmp://203.207.99.19:1935/live/aaa
(rtmp://203.207.99.19:1935/live/CCTV1)
- rtmp://202.117.80.19:1935/live/aaa
(rtmp://202.117.80.19:1935/live/live4)
- rtmp://ams.studytv.cn/live/aaa 
(rtmp://ams.studytv.cn/livepkgr/264)
- rtmp://60.174.36.89:1935/live/aaa 
(rtmp://60.174.36.89:1935/live/vod3)

[想做一套直播系统？看我就够了](http://www.jianshu.com/p/5b1341e97757)


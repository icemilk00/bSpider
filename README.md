# 祝福短信大全  
#### 之前为了练习python的爬虫和服务器端写的项目，很简单。  
#### 记录一下更新操作步骤：  
1. 爬取新数据  
  
        $cd bSpider/www/dataSource
        $python3 spiderForCategory.py
        ...
        $python3 bSpider.py
        ...
 完毕后会得到两个数据文件，保存格式为json，简单的数据源

2. 部署到服务器

        $cd bSpider 
        $fab build
        ...
        $fab deploy
        ...
 build 会把服务器相关的代码打包，deploy会直接传到服务器上部署好，并且重启服务器，但是数据源没有更新。

3. 去服务器手动更新数据源  
去服务器找到刚才上传上来的服务器文件，找到save_sms.py, 并执行

        $python3 save_sms.py


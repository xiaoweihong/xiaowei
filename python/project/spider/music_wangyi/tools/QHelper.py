#!/usr/bin/env python
# _*_ coding:UTF-8_*_

import useragent_list
import urllib2
import random

class QHelper(object):
    
    def __init__(self):
        self.__UserAgent_list = useragent_list.UserAgent_List
        self.__Url_test="http://www.baidu.com"    #测试网址
        self.__timeout=1                          #超时时间
    
     #获取代理IP
    def GetIpPage(self,URL):
        headers = self.GetHeader()
        req = urllib2.Request(URL,headers=headers)
        response = urllib2.urlopen(req)
        return response.read().decode('utf-8')
        
    #获取随机的header    
    def GetHeader(self):
        return {'User-Agent': random.choice(self.__UserAgent_list),
             'Accept': "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
             'Cache-Control': 'no-cache',
             'Upgrade-Insecure-Requests': '1',
             }

        
QHelper().GetIpPage("http://www.xicidaili.com/wt/")
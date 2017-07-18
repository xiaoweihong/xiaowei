#!/usr/bin/env python
# _*_ coding:UTF-8_*_

import re
import urllib2
from tools.QHelper import QHelper
import random
import time

class IPTools(object):
    
    def __init__(self):
        self.__Url_test="http://www.baidu.com"    #测试网址
        self.__timeout=1                          #超时时间
        self.__Url_ip="http://www.youdaili.net/Daili/http/33108.html"   #获取代理IP的地址
        self.__Num_ip=10                                                 #准备采集多少个IP备用
    
    
    #获取用于访问地址的代理ip地址
    def Get_IPlist(self,URL):
        Ip_list=[]
        Ip_Page = QHelper().GetIpPage(URL)
#         pattern = '<td>(.*?)</td>'
#         pattern = '<tr class="odd">\n      <td class="country"></td>\n      <td>(.*?)</td>\n      <td>(.*?)</td>.*?</tr>'
        
        pattern ='\d+.\d+.\d+.\d+:\d+'
        ips = re.findall(pattern, Ip_Page, re.S)
        for ip in ips:
            if self.Test_IP(ip, self.__Url_test, self.__timeout):
                Ip_list.append(ip)
                print u'测试通过，IP地址为'+str(ip)
                if len(Ip_list)>self.__Num_ip-1:
                    print u'搜集到'+str(len(Ip_list))+u'个合格的IP地址'
                    return Ip_list
            
    #获取可用的IP地址
    def Test_IP(self,IP,URL_test,set_timeout=1):
        try:
            proxy = urllib2.ProxyHandler({'http':IP})
            opener = urllib2.build_opener(proxy)
            urllib2.install_opener(opener)
            
            req = urllib2.Request(URL_test,headers=QHelper().GetHeader())
            response = urllib2.urlopen(req)
            return True
        except:
            return False
    #获取随机ip    
    def Get_randomIP(self,Ip_list):
        ind = random.randint(0,len(Ip_list)-1)
        return Ip_list[ind]
    #模拟访问网站
    def Access_page(self,URL):
        
        Ip_list = self.Get_IPlist(self.__Url_ip)
        count = 1
        while True:
                IP = self.Get_randomIP(Ip_list)
                print u'开始第%d次刷网页………………,'%count+u'ip地址是:'+IP
                count=count+1
                try:
                    proxy = urllib2.ProxyHandler({'http':IP})
                    opener = urllib2.build_opener(proxy)
                    urllib2.install_opener(opener)
                        
                    req = urllib2.Request(URL,headers=QHelper().GetHeader())
                    response = urllib2.urlopen(req)
                    time.sleep(1)
                except:
                   print u'连接失败'        
                        
IPTools().Access_page("http://www.shashou47.com")
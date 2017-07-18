# _*_coding:UTF-8_*_

from tools.QHelper import QHelper
from bs4 import BeautifulSoup
import requests
import os
import time


class HeisiBa:

    '''
        初始化变量
    '''
    def __init__(self):

        self.url = "https://tieba.baidu.com/p/"    #百度贴吧地址
        self.headers = QHelper().GetHeader()        #浏览器的请求头，防止被网站爬
        self.folder_path = "d:\pic\heisi"           #图片保存地址


    '''
       获得帖子总页数
    '''
    def getPageNum(self,url):
        response = self.request(url)

        page_nums = BeautifulSoup(response.text, 'lxml').find_all('span', class_="red")
        try:
            if len(page_nums):
                return page_nums[1].contents

        except:
                print "地址不正确"


    '''
       请求网址
    '''

    def request(self,url):
        response = requests.get(url,headers=self.headers)
        return response

    '''
       创建文件夹
    '''
    def mkdir(self,path):
        path = path.strip()
        #判断是否存在文件夹
        isexits = os.path.exists(path)

        if not isexits:
            print "创建名叫做"+path+"的文件夹"
            os.makedirs(path)
            print "文件夹创建成功"
        else:
            print "文件夹已经存在"

    '''
        保存图片
    '''
    def save(self,url,name):

        img =self.request(url)
        time.sleep(1)
        file_name = name+'.jpg'
        print "保存图片..."+file_name
        f = open(file_name,'ab')
        f.write(img.content)
        f.close()

    '''
        获得楼主的图片
    '''
    def get_Pic(self,url_a,pageNum):
        for m in range(int(pageNum[0])):
            url = url_a + "&pn=" + str(m + 1)
            print "贴吧地址是:" + url

            print "开始网页请求"
            response = self.request(url)
            all_imgs = BeautifulSoup(response.text, 'lxml').find_all('img', class_="BDE_Image")

            print '开始创建文件夹'
            self.mkdir(self.folder_path)
            print '开始切换文件夹'
            os.chdir(self.folder_path)
            i = 1

            for a in all_imgs:
                self.save(a['src'], "page" + str(m) + "-" + str(i))
                i = i + 1

    '''
        下载的函数
    '''
    def download(self):
        while True:
            self.MainMenu()
            choice = raw_input("请输入您要选择的功能：")
            if choice == str(3):
                print "您已经退出系统！"
                break
            elif choice == str(2):
                print "开始下载楼主的图片"
                tieNo = raw_input("请输入百度贴吧地址(只要/p/1625243294)：")
                url_a = self.url + str(tieNo) + "?see_lz=1"
                pageNum = self.getPageNum(url_a)
                self.get_Pic(url_a,pageNum)
            elif choice == str(1):
                tieNo = raw_input("请输入百度贴吧地址(只要/p/1625243294)：")
                url_a = self.url + str(tieNo)
                pageNum = self.getPageNum(url_a)
                # print "***********"+pageNum[0]
                self.get_Pics(url_a,pageNum)

            else:
                print "请输入正确的数字！！"
                continue


    '''
        获得所有图片
    '''
    def get_Pics(self,url_b,pageNum):
        print "开始网页请求,批量下载图片"
        if pageNum:
            for m in range(int(pageNum[0])):
                url = url_b+"?pn="+str(m)
                response = self.request(url)
                all_imgs = BeautifulSoup(response.text,'lxml').find_all('img', class_="BDE_Image")

                print '开始创建文件夹'
                self.mkdir(self.folder_path)
                print '开始切换文件夹'
                os.chdir(self.folder_path)
                print "******************"
                i = 1
                for a in all_imgs:
                    self.save(a['src'],str(m)+"-"+str(i))
                    i=i+1
                url = ""
        else:
            print "地址不正确，请重新输入"
            time.sleep(5)

    '''
        主菜单
    '''
    def MainMenu(self):

        print '''
        ***************************
        欢迎使用百度贴吧图片保存系统
        版本号：v1.0
        更新日期：2017-3-8
        author:xiaowei
        请选择：
            1、下载所有图片
            2、下载楼主的图片
            3、退出
        ***************************
        '''

    '''
        二级菜单
    '''
    def picMenu(self):
        print '''
        请选择：
            1、下载所有图片（包括每个发言）
            2、只下载楼主发的图
            0、退回到上级
        '''




if __name__ == '__main__':

    HeisiBa().download()



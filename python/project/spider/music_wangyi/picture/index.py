#_*_coding:UTF-8_*_
import requests
from tools.QHelper import QHelper
from bs4 import BeautifulSoup
import os
import time

class BeautifulPicture():

    def __init__(self):
        self.headers = QHelper().GetHeader()
        self.web_url = "https://unsplash.com"
        self.folder_path ="d:\pic"

    def request(self,url="https://unsplash.com"):
        response = requests.get(url,headers=self.headers)
        return response


    def mkdir(self,path):
        path = path.strip()
        isExists = os.path.exists(path)
        if not isExists:
            print u'创建名字叫做',path,'的文件夹'
            os.makedirs(path)
            print u'创建成功'
        else:
            print path,'文件夹已经存在，不在创建'

    def save_img(self,url,name):
        print u'开始保存图片...'
        img = self.request(url)
        time.sleep(5)
        file_name = name+".jpg"
        print u'开始保存文件'+file_name
        f = open(file_name,'ab')
        f.write(img.content)
        f.close()

    def get_pic(self):
        print u'开始网页请求'
        response = self.request(self.web_url)
        print u'开始获取所有a标签'
        all_a = BeautifulSoup(response.text, 'lxml').find_all('a', class_="cV68d")
        print u'开始创建文件夹'
        self.mkdir(self.folder_path)
        print u'开始切换文件夹'
        os.chdir(self.folder_path)
        i =1
        for urls in all_a:
            img_str = urls['style']
            urls_tmp = img_str[img_str.index('"') + 1:]
            img_urls = urls_tmp[:urls_tmp.index('"')]
            img_url_final = img_urls[:img_urls.index('?')]
            self.save_img(img_url_final,str(i))
            i = i+1

beauty = BeautifulPicture()
beauty.get_pic()

# print beauty.request().text
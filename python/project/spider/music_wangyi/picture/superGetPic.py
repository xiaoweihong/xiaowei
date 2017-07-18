#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/3/9 9:28
# @Author  : xiaowei
# @Site    : 
# @File    : superGetPic.py
# @Software: PyCharm

import os  # 导入os模块
import time

import requests
from bs4 import BeautifulSoup  # 导入BeautifulSoup 模块
from selenium import webdriver  # 导入Selenium

from tools.QHelper import QHelper


class BeautifulPicture():
    def __init__(self):
        self.headers = QHelper().GetHeader()
        self.web_url = 'https://unsplash.com'
        self.folder_path = 'd:\pic\super'

    def get_pic(self):
        print '开始网页请求'
        driver = webdriver.PhantomJS()
        driver.get(self.web_url)
        self.scroll_down(driver=driver, times=1)
        print "开始获取所有a标签"
        all_a = BeautifulSoup(driver.page_source, 'lxml').find_all('a', class_='cV68d')
        print '开始创建文件夹'
        is_new_folder = self.mkdir(self.folder_path)  # 创建文件夹，并判断是否是新创建
        print '开始切换文件夹'
        os.chdir(self.folder_path)  # 切换路径至上面创建的文件夹

        print "a标签的数量是：", len(all_a)  # 这里添加一个查询图片标签的数量，来检查我们下拉操作是否有误
        file_names = self.get_files(self.folder_path)  # 获取文件家中的所有文件名，类型是list

        for a in all_a:  # 循环每个标签，获取标签中图片的url并且进行网络请求，最后保存图片
            img_str = a['style']  # a标签中完整的style字符串
            print 'a标签的style内容是：' + img_str
            first_pos = img_str.index('(') + 1
            second_pos = img_str.index(')')
            img_url = img_str[first_pos: second_pos]  # 使用Python的切片功能截取双引号之间的内容

            name_start_pos = img_url.index('.com/') + 5  # 通过找.com/的位置，来确定它之后的字符位置
            name_end_pos = img_url.index('?')
            img_name = img_url[name_start_pos: name_end_pos] + '.jpg'
            img_name = img_name.replace('/', '')  # 把图片名字中的斜杠都去掉

            img_url = self.get_BigImg(img_url)

            if is_new_folder:
                self.save_img(img_url, img_name)  # 调用save_img方法来保存图片
            else:
                if img_name not in file_names:
                    self.save_img(img_url, img_name)  # 调用save_img方法来保存图片
                else:
                    print '该图片已经存在：' + img_name + '，不再重新下载。'

    # 注：为了尽快看到下拉加载的效果，截取高度和宽度部分暂时注释掉，因为图片较大，请求时间较长。
    # 获取高度和宽度的字符在字符串中的位置
    def get_BigImg(self, img_url):

        width_pos = img_url.index('&w=')
        height_pos = img_url.index('&q=')
        width_height_str = img_url[width_pos: height_pos]  # 使用切片功能截取高度和宽度参数，后面用来将该参数替换掉
        print '高度和宽度数据字符串是：' + width_height_str
        img_url_final = img_url.replace(width_height_str, '')  # 把高度和宽度的字符串替换成空字符
        print '截取后的图片的url是：' + img_url_final
        return img_url_final

    def save_img(self, url, file_name):  ##保存图片
        print '开始请求图片地址，过程会有点长...'
        img = self.request(url)
        print '开始保存图片'
        f = open(file_name, 'ab')
        f.write(img.content)
        print file_name + '图片保存成功！'
        f.close()

    def request(self, url):  # 返回网页的response
        r = requests.get(url)  # 像目标url地址发送get请求，返回一个response对象。有没有headers参数都可以。
        return r

    def mkdir(self, path):  ##这个函数创建文件夹
        path = path.strip()
        isExists = os.path.exists(path)
        if not isExists:
            print '创建名字叫做' + path + '的文件夹'
            os.makedirs(path)
            print '创建成功！'
            return True
        else:
            print path, '文件夹已经存在了，不再创建'
            return False

    def scroll_down(self, driver, times):
        for i in range(times):
            print "开始执行第" + str(i + 1) + "次下拉操作"
            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            print "第" + str(i + 1) + "次下拉操作执行完毕"
            print "第" + str(i + 1) + "次等待网页加载......"
            time.sleep(3)  # 等待30秒，页面加载出来再执行下拉操作

    def get_files(self, path):
        pic_names = os.listdir(path)
        return pic_names


print BeautifulPicture().get_files("d:\pic\super")

#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/3/9 10:36
# @Author  : xiaowei
# @Site    : 
# @File    : get163pic.py
# @Software: PyCharm

from bs4 import BeautifulSoup
from selenium import webdriver

from tools.pictools import *


class AlbumCover_163:
    def __init__(self):
        self.init_url = "http://music.163.com/#/artist/album?id=101988&limit=120&offset=0"
        self.folder_path = "d:\pic\\163"

    def spider(self):

        print "开始抓取专辑图片...."
        driver = webdriver.PhantomJS(service_args=['--load-images=no'])
        driver.get(self.init_url)
        driver.switch_to.frame("g_iframe")
        html = driver.page_source
        # print html

        print "开始创建文件夹"
        mkdir(self.folder_path)
        print "开始切换文件夹"
        os.chdir(self.folder_path)

        file_names = get_files(self.folder_path)

        all_li = BeautifulSoup(html, 'lxml').find(id='m-song-module').find_all('li')
        for li in all_li:
            album_img = li.find('img')['src']
            album_name = li.find('p')['title']
            album_date = li.find('span').get_text()
            album_img_url = album_img[:album_img.index('?')]
            photo_name = album_date + ' - ' + album_name.replace('/', '').replace(':', ',') + '.jpg'
            print album_img_url, photo_name
            if photo_name in file_names:
                print "图片已经存在，不再重复下载"
            else:
                save_img(album_img_url, photo_name)


if __name__ == '__main__':
    AlbumCover_163().spider()

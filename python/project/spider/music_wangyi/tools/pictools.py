#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/3/9 10:37
# @Author  : xiaowei
# @Site    : 
# @File    : pictools.py
# @Software: PyCharm
import os
import time

import requests

from QHelper import QHelper


def save_img(url, file_name):  ##保存图片
    print '开始请求图片地址，过程会有点长...'
    img = request(url)
    print '开始保存图片'
    f = open(file_name, 'ab')
    f.write(img.content)
    print '图片保存成功！'
    f.close()
    time.sleep(1)


def request(url):  # 返回网页的response
    r = requests.get(url, headers=QHelper().GetHeader())  # 像目标url地址发送get请求，返回一个response对象。有没有headers参数都可以。
    return r


def mkdir(path):  ##这个函数创建文件夹
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


def scroll_down(driver, times):
    for i in range(times):
        print "开始执行第" + str(i + 1) + "次下拉操作"
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        print "第" + str(i + 1) + "次下拉操作执行完毕"
        print "第" + str(i + 1) + "次等待网页加载......"
        time.sleep(3)  # 等待30秒，页面加载出来再执行下拉操作


def get_files(path):
    pic_names = os.listdir(path)
    return pic_names

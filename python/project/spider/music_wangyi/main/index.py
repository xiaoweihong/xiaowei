#_*_coding:utf-8_*_
from bs4 import BeautifulSoup
import requests
from tools.QHelper import QHelper

web_url = 'https://unsplash.com'
r = requests.get(web_url, headers=QHelper().GetHeader())

all_a = BeautifulSoup(r.text,'lxml').find_all('a',class_="cV68d")

for a in all_a:
    img_str = a['style']
    # print img_str.index[:img_str['"',]
    m = img_str[img_str.index('"')+1:]
    b = m[:m.index('"')]
    img_urls = m[:m.index('"')]

    img_url = img_urls[:img_urls.index('?')]
    # width_pos = img_urls.index('&w=')
    # height_pos = img_urls.index('&q=')
    # img_url_final = img_urls.replace(img_urls[width_pos : height_pos], '')
    print m

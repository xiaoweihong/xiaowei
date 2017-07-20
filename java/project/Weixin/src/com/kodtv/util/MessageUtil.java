package com.kodtv.util;

import com.kodtv.entity.TextMessage;
import com.thoughtworks.xstream.XStream;
import java.io.InputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class MessageUtil
{
  public static final String MESSAGE_TEXT = "text";
  public static final String MESSAGE_IMAGE = "image";
  public static final String MESSAGE_VOICCE = "voice";
  public static final String MESSAGE_VIDEO = "video";
  public static final String MESSAGE_LINK = "link";
  public static final String MESSAGE_LOCATION = "location";
  public static final String MESSAGE_EVENT = "event";
  public static final String MESSAGE_SUBSCRIBE = "subscribe";
  public static final String MESSAGE_CLICK = "CLICK";
  public static final String MESSAGE_VIEW = "VIEW";
  
  public static Map<String, String> xmlToMap(HttpServletRequest request)
    throws Exception
  {
    Map<String, String> map = new HashMap();
    
    SAXReader reader = new SAXReader();
    
    InputStream ins = request.getInputStream();
    
    Document doc = reader.read(ins);
    Element root = doc.getRootElement();
    
    List<Element> list = root.elements();
    for (Element e : list) {
      map.put(e.getName(), e.getText());
    }
    ins.close();
    return map;
  }
  
  public static String textMessageToXml(TextMessage textMessage)
  {
    XStream xstream = new XStream();
    xstream.alias("xml", textMessage.getClass());
    return xstream.toXML(textMessage);
  }
  
  public static String initText(String toUserName, String fromUserName, String content)
  {
    TextMessage text = new TextMessage();
    text.setFromUserName(toUserName);
    text.setToUserName(fromUserName);
    text.setMsgType("text");
    text.setCreateTime(new Date().getTime());
    text.setContent(content);
    return textMessageToXml(text);
  }
  
  public static String menuText()
  {
    StringBuffer sb = new StringBuffer();
    sb.append("欢迎您的关注，请按照菜单提示进行操作：\n");
    sb.append("1、KOD介绍\n");
    sb.append("2、KODTV介绍\n\n");
    sb.append("回复?调出菜单。");
    return sb.toString();
  }
  
  public static String firstMenu()
  {
    StringBuffer sb = new StringBuffer();
    sb.append("全球著名世界街舞大赛之一，精彩尽在www.kodtv.com");
    return sb.toString();
  }
  
  public static String secondMenu()
  {
    StringBuffer sb = new StringBuffer();
    sb.append("全球综合街舞教育平台。");
    return sb.toString();
  }
}

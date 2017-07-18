package com.kodtv.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kodtv.entity.TextMessage;
import com.kodtv.util.CheckUtil;
import com.kodtv.util.MessageUtil;

public class WeixinServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	  
	  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	    throws ServletException, IOException
	  {
	    String signature = req.getParameter("signature");
	    String timestamp = req.getParameter("timestamp");
	    String nonce = req.getParameter("nonce");
	    String echostr = req.getParameter("echostr");
	    
	    PrintWriter out = resp.getWriter();
	    if (CheckUtil.checkSignature(signature, timestamp, nonce)) {
	      out.println(echostr);
	    }
	  }
	  
	  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			    throws ServletException, IOException
		{
		  req.setCharacterEncoding("UTF-8");
		  resp.setCharacterEncoding("UTF-8");
		  PrintWriter out = resp.getWriter();
		      
		  try {
			Map<String,String> map = MessageUtil.xmlToMap(req);
			String fromUserName = map.get("FromUserName");
			String toUserName = map.get("ToUserName");
			String msgType = map.get("MsgType");
			String content = map.get("Content");
			
			String message = null;
			
			if(MessageUtil.MESSAGE_TEXT.equals(msgType)){
				
				if("1".equals(content)){
				message	= MessageUtil.initText(toUserName, fromUserName, MessageUtil.firstMenu());
				}else if ("2".equals(content))
				{
				message	= MessageUtil.initText(toUserName, fromUserName, MessageUtil.secondMenu());	
					
				}else if("?".equals(content)||"？".equals(content)){
				message	= MessageUtil.initText(toUserName, fromUserName, MessageUtil.menuText());	
				}
				
			}else if (MessageUtil.MESSAGE_EVENT.equals(msgType)) {
				String eventType = map.get("Event");
				if(MessageUtil.MESSAGE_SUBSCRIBE.equals(eventType)){
				message	= MessageUtil.initText(toUserName, fromUserName, MessageUtil.menuText());
				}
			}
			out.print(message);
			System.out.println(message);
		  } catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		}
}

package com.kodtv.util;

import java.security.MessageDigest;
import java.util.Arrays;

public class CheckUtil
{
  private static final String token = "kodtvs";
  
  public static boolean checkSignature(String signature, String timestamp, String nonce)
  {
    String[] arr = { token, timestamp, nonce };
    
    Arrays.sort(arr);
    
    StringBuffer content = new StringBuffer();
    for (int i = 0; i < arr.length; i++) {
      content.append(arr[i]);
    }
    String temp = geteSha1(content.toString());
    System.out.println("****************"+temp);
    return temp.equals(signature);
  }
  
  public static String geteSha1(String str)
  {
    if ((str == null) || (str.length() == 0)) {
      return null;
    }
    char[] hexDigits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    try
    {
      MessageDigest mdTemp = MessageDigest.getInstance("SHA1");
      mdTemp.update(str.getBytes("UTF-8"));
      
      byte[] md = mdTemp.digest();
      int j = md.length;
      char[] buf = new char[j * 2];
      int k = 0;
      for (int i = 0; i < j; i++)
      {
        byte byte0 = md[i];
        buf[(k++)] = hexDigits[(byte0 >>> 4 & 0xF)];
        buf[(k++)] = hexDigits[(byte0 & 0xF)];
      }
      return new String(buf);
    }
    catch (Exception e) {}
    return null;
  }
}

#**********************************************************
# * Author        : xiaowei
# * Email         : 403828237@qq.com
# * Last modified : 2017-10-13 10:47
# * Filename      : colors.sh
# * Description   : 
# * *******************************************************
#!/bin/bash
Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}

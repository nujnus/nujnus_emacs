ssh root@192.168.3.57 "test -e /opt/pydev/${1}.ipynb > /dev/null 2>&1"
if [ $? -eq 0 ]
  then
    echo "File exists"
  else
    ssh root@192.168.3.57  "cp /opt/pydev/template.ipynb /opt/pydev/${1}.ipynb"
fi

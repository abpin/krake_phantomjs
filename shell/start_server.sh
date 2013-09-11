# Setting of the pid variable
#   no spacing allowing between variable and equal sign
# pid=`ps aux | grep server.js | grep -v grep | awk '{printf $2}'`;
# "^[0-9]*$"
echo '[PHANTOM — start_server.sh] : Killing all new nohup server.js background processes'
ps aux | grep server.js | grep -v grep | awk '{print $2}' | xargs kill


echo '[PHANTOM — start_server.sh] : starting new nohup server.js'
nohup phantomjs ../server.js > ../logs/server_log 2>&1 &
##Basic requirements
[ubuntu kylin 14.04/16.04 lts](http://www.ubuntukylin.com/downloads/)

[redis desktop manager](https://github.com/uglide/RedisDesktopManager/releases)

## Ubuntu setup
```
sudo apt-get install autoconf libreadline-dev git gitg
```

## Building from source
```
git clone https://github.com/charleeli/quick-standalone.git
cd quick-standalone
make
```

## Test
```
启动账号服务器
./build/bin/redis-server ./config/database/accountdb.conf

启动存储服务器
./build/bin/redis-server ./config/database/gamedb.conf

启动游戏服务器
./build/bin/skynet config/config.game

启动客户端
cd ./tool/simpleclient/
../../build/bin/lua simpleclient.lua
```

## 工作原理

1. snmp-collector-plugin 监控插件包使用了第三方的 SNMP Exporter 进行指标采集，GitHub 链接为 https://github.com/prometheus/snmp_exporter 。

## 准备工作

1. 确认要采集的路由器、交换机等硬件设备启用了 SNMP，包括其具体的管理 IP、团体字。
2. 该监控插件包默认只会采集硬件设备的通用 OID 指标数据，如果需要采集特定型号的硬件设备的指标数据，需要对应的完整 MIB 库。

## 使用方法

### 导入监控插件包

1. 下载该项目的压缩包（https://github.com/easy-monitor/snmp-collector-plugin/archive/master.zip ）。

2. 建议解压到 EasyOps 平台服务器上的 `/usr/local/easyops/monitor_plugin_packages` 该目录下。

3. 使用 EasyOps 平台内置的监控插件包导入工具进行导入，具体命令如下，请替换其中的 `8888` 为当前 EasyOps 平台具体的 `org`。

```sh
$ cd /usr/local/easyops/collector_plugin_service/tools
$ sh plugin_op.sh install 8888 /usr/local/easyops/monitor_plugin_packages/snmp-collector-plugin
```

4. 导入成功后访问 EasyOps 平台的「采集插件」小产品页面 (http://your-easyops-server/next/collector-plugin )，就能看到导入的 "snmp-collector-plugin" 采集插件。

### 启动 SNMP Exporter

1. 在 conf 目录下已经提供了一个基本的配置文件，启动命令默认使用 `conf/snmp.yml`，该配置文件采集规则会采集所有通用 OID 的指标。如果需要采集特定型号的硬件设备指标数据，可以使用 `tools/generator` 工具从指定的 MIB 库来自动生成 `snmp.yml` 配置文件。具体使用方法请参考 https://github.com/prometheus/snmp_exporter/tree/master/generator 。

```sh
$ export MIBDIRS=mibs    # MIB 库目录，默认为当前目录下的 mibs 目录
$ ./generator generate
```

2. 编辑 conf/snmp.yml 配置文件，配置具体的团体字。

```
if_mibs:
  ...
  auth:
    community: public
```

3. 在启动时指定选择的配置文件，具体命令如下，请替换其中的 `--config—file-path` 参数为具体选择的配置文件路径。

```sh
$ cd /usr/local/easyops/monitor_plugin_packages/snmp-collector-plugin/script
$ sh deploy/start_script.sh --config-file-path conf/snmp.yml
```

3. 通过访问 http://127.0.0.1:9116/snmp?target=1.2.3.4 来获取指标数据，请替换其中的 `127.0.0.1:9116` 为 Exporter 具体的监听地址和端口，target 参数为 H3C 交换机具体的管理 IP。

```sh
$ curl http://127.0.0.1:9116/snmp?target=1.2.3.4 
```

5. 接下来可使用导入的采集插件为具体的资源实例创建采集任务。

## 启动参数

| 名称 | 类型 | 默认值 | 说明 |
| ---- | ---- | ---- | ---- |
| config-file-path | string | conf/snmp.yml | 配置文件路径 |
| exporter-host | string | 127.0.0.1 | Exporter 监听地址 |
| exporter-port | int | 9116 | Exporter 监听端口 |

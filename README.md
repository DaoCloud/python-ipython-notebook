# 如何开发一个 Python 的 Docker 化应用

> 目标：用 Docker 镜像的方式搭建一个 IPython Notebook 应用
> 
> 本项目代码维护在 **[DaoCloud/python-ipython-notebook](https://github.com/DaoCloud/python-ipython-notebook)** 项目中。

### 前言

Python 家族成员繁多，解决五花八门的业务需求。这里将通过 Python 明星项目 IPython Notebook，使其容器化，让大家掌握基础的 Docker 使用方法。

> IPython Notebook 目前已经成为用 Python 做教学、计算、科研的一个重要工具。

### Docker 化应用的关键元素

- 镜像是 Docker 应用的静态表示，是应用的交付件，镜像中包含了应用运行所需的所有依赖：包括应用代码、应用依赖库、应用运行时和操作系统。
- Dockerfile 是一个描述文件，描述了产生 Docker 镜像的过程，详细文档请参见 [Dockerfile 文档](https://docs.docker.com/reference/builder/)。
- 容器是镜像运行时的动态表示，如果把镜像想象为一个 Class 那么容器就是这个 Class 的 instance 实例。

一个应用 Docker 化的第一步就是通过 Dockerfile 产生应用镜像。

#### 编写Dockerfile

选择 Python 2.7 版本为我们依赖的系统镜像。

``` dockerfile
FROM python:2.7
```

> 因所有官方镜像均位于境外服务器，为了确保所有示例能正常运行，DaoCloud 提供了一套境内镜像源，并与官方源保持同步。如果使用 DaoCloud 的镜像源，则指向：`FROM daocloud.io/python:2.7`。   
> 
> 也推荐通过 Dao toolbox 极速下载官方镜像！

``` dockerfile
MAINTAINER Captain Dao <support@daocloud.io>
```

设置镜像的维护者，相当于镜像的作者或发行方。

``` dockerfile
RUN mkdir -p /app
WORKDIR /app
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
```

`ADD` 与 `COPY` 的区别，总体来说 `ADD` 和 `COPY` 都是添加文件的操作，其中 `ADD` 比 `COPY` 功能更多，`ADD` 允许后面的参数为 URL，还有 `ADD` 添加的文件为压缩包的话，它将自动解压。

用 RUN 命令调用 PIP 包管理器安装 App 所依赖的程序包

``` dockerfile
EXPOSE 8888

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
```

`EXPOSE` 指定暴露的容器端口（8000）。

`CMD` 为本次构建出来的镜像运行起来时候默认执行的命令，我们可以通过 `docker run` 的启动命令修改默认运行命令。

### 制作启动脚本 (docker-entrypoint.sh)

``` sh
#!/bin/bash
# Strict mode
set -euo pipefail


# Create the hash to pass to the IPython notebook, but don't export it so it doesn't appear
# as an environment variable within IPython kernels themselves
HASH=$(python3 -c "from IPython.lib import passwd; print(passwd('${PASSWORD:-admin}'))")
unset PASSWORD

echo "========================================================================"
echo "You can now connect to this Ipython Notebook server using, for example:"
echo ""
echo "	docker run -d -p <your-port>:8888 -e password=<your-password> ipython/noetbook"
echo ""
echo "  use password: ${PASSWORD:-admin} to login"
echo ""
echo "========================================================================"

ipython notebook --no-browser --port 8888 --ip=* --NotebookApp.password="$HASH"
```

### 运行容器

Dockerfile 具体语法请参考：[Dockerfile](https://docs.docker.com/reference/builder/) 。

有了 Dockerfile 以后，我们可以运行下面的命令构建 Python 应用镜像并命名为 `ipython/notebook`：

- 通过指令建立镜像

``` 
docker bulid -t ipython/notebook .
```

- 通过以下指令启动容器

``` 
docker run -d -p 8888:8888 -e password=admin ipython/notebook 
```

注意哦，我们将初始登录密码通过环境变量告知应用。

打开游览器，访问 8888 端口，就可以看到 IPython Notebook 了。

![ipython login](http://blog.daocloud.io/wp-content/uploads/2015/09/QQ20150902-1.png)

![](http://blog.daocloud.io/wp-content/uploads/2015/09/QQ20150902-2.png)

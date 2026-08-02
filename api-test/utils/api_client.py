"""接口请求客户端，封装Token 和统一请求"""
import requests
import allure
from config import BASE_URL, API_PREFIX, REQUEST_TIMEOUT
import logging
from datetime import datetime     # 获取当前时间，每条日志带时间戳
from pathlib import Path

LOG_DIR = Path(__file__).parent.parent / "logs"     # api-test/logs/
LOG_DIR.mkdir(exist_ok=True)                        # 目录不存在就创建
log_file = LOG_DIR / f"api_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"# 示例：logs/api_20260728_143001.log
logger = logging.getLogger("api_client")            #创建当前模块的日志器
logger.setLevel(logging.DEBUG)                      #记录所有级别的日志

  # 文件处理器：把日志写入文件（utf-8 保证中文不乱码）
fh = logging.FileHandler(log_file, encoding="utf-8")
fh.setLevel(logging.DEBUG)
fh.setFormatter(logging.Formatter("%(asctime)s | %(message)s",datefmt="%Y-%m-%d %H:%M:%S"))
logger.addHandler(fh)

class APIClient:


    def __init__(self, base_url: str = BASE_URL):
          """__init__：创建类实例对象时，自动执行
              作用：给新建的对象初始化属性、配置资源。self代表当前正在创建的实例对象。
          """
#           : str：类型注解，标记这个参数必须是字符串；
#           = BASE_URL：默认值，如果创建客户端时不传域名，自动读取全局配置的 BASE_URL。
          self.base_url = base_url.rstrip("/")
          self.session = requests.Session()
          self.session.headers.update({
              "Content-Type": "application/json",#告诉后端，请求体是 JSON 格式；
              "Accept": "application/json",#告诉后端，客户端只接收 JSON 格式的返回数据；
          })
          self._token = None

    @property#把下面的方法伪装成对象的属性,之后可以用 client.token 读取，像访问变量一样，不用加括号
    def token(self):
          return self._token#下划线代表私有

    @token.setter#赋值装饰器，绑定上方@property的token属性
    def token(self, value: str):
          self._token = value
          self.session.headers.update({"Authorization": value})
      #私有方法
    def _request(self,method:str,path:str,**kwargs):#**kwargs: 接收所有额外参数（如 json=、params=）
          url=f"{self.base_url}{API_PREFIX}{path}"
          body = kwargs.get("json", "")
          logger.info(f"--> {method} {path}  {body}")#发送前记录：方向+接口+请求体
          kwargs.setdefault("timeout", REQUEST_TIMEOUT) #给 kwargs 里面的 timeout 参数设置默认值
          resp = self.session.request(method, url, **kwargs)
          resp.raise_for_status() #自动判断 HTTP 状态码,不是200抛异常
          json_data = resp.json()  # 先存到变量，既要返回也要记日志

          logger.info(f"<-- {resp.status_code}  {json_data}")#收到响应后记录：状态码+响应体
          return resp.json() #响应体从 JSON 字符串转成 Python 字典返回


    def get(self, path, **kwargs):
            return self._request("GET", path, **kwargs)

    def post(self, path, **kwargs):
            return self._request("POST", path, **kwargs)

    def put(self, path, **kwargs):
            return self._request("PUT", path, **kwargs)

    def delete(self, path, **kwargs):
            return self._request("DELETE", path, **kwargs)

import os

BASE_URL = os.getenv("BASE_URL", "http://localhost:8081")#os.getenv("变量名", "默认值")
API_PREFIX = "/api"#后端所有接口统一前缀
REQUEST_TIMEOUT = 15
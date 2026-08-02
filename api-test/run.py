"""
测试运行入口：跑用例 → 生成 Allure 报告 → 浏览器打开
"""
import sys          # sys.executable -> 获取当前 Python 路径，保证调的是 venv 里的 pytest
import yaml          # 读取 yaml 配置文件
import subprocess   # 调用操作系统终端命令，（Windows cmd / Mac/Linux shell）
from pathlib import Path  # 现代化路径操作

PROJECT_ROOT = Path(__file__).parent                     # api-test/
ALLURE_RESULTS = PROJECT_ROOT / "reports" / "allure-results"  # pytest 输出的原始 JSON
ALLURE_REPORT = PROJECT_ROOT / "reports" / "allure-report"   # 生成的 HTML

def load_test_plan():
    """
    读取 test_plan.yaml，拼出 pytest -k 的筛选表达式
    例：include=["register","login"], exclude=["duplicate"]
    →  -k "(register or login) and not (duplicate)"
    """
    plan_file = PROJECT_ROOT / "test_plan.yaml"
    if not plan_file.exists():
        return None  # 没有 yaml 文件就不加 -k 参数，跑全部用例

    with open(plan_file, encoding="utf-8") as f:
        plan = yaml.safe_load(f)

    include = plan.get("include", [])
    exclude = plan.get("exclude", [])

    # 拼 include 部分："register or login"
    expr_parts = []
    if include:
        expr_parts.append(f"({' or '.join(include)})")
    # 拼 exclude 部分："not (duplicate)"
    if exclude:
        expr_parts.append(f"not ({' or '.join(exclude)})")

    if not expr_parts:
        return None

    # 用 " and " 连接："(register or login) and not (duplicate)"
    return " and ".join(expr_parts)

def run_tests():
    """执行 pytest，支持从 yaml 筛选用例"""
    # sys.executable → 当前 venv 的 python.exe 完整路径
    # -m pytest      → python -m pytest 等效于直接敲 pytest，但确保用的是 venv 里的版本
    cmd = [sys.executable, "-m", "pytest"]
    # 读取 yaml 配置，如果有筛选条件就加 -k 参数
    keyword_expr = load_test_plan()
    if keyword_expr:
        cmd.extend(["-k", keyword_expr])
        print(f"[INFO] 筛选用例: -k \"{keyword_expr}\"")

    print(f"\n{'='*50}\n[RUN] 测试执行...\n{'='*50}")
    # subprocess.run: 运行命令，等待执行完才继续
    # capture_output=False: 让 pytest 的输出实时显示在控制台上
    result = subprocess.run(cmd, cwd=PROJECT_ROOT)
    return result.returncode  # 0=全部通过，非0=有失败

    print(f"\n{'='*50}\n[RUN] 测试执行...\n{'='*50}")
    # subprocess.run: 运行命令，等待执行完才继续
    # capture_output=False: 让 pytest 的输出实时显示在控制台上
    result = subprocess.run(cmd, cwd=PROJECT_ROOT)
    return result.returncode  # 0=全部通过，非0=有失败

def serve_report():
    """JSON -> HTML 网页，启动本地服务，自动弹浏览器"""
    print(f"\n{'='*50}\n[REPORT] 生成 Allure report...\n{'='*50}")
    # allure generate: JSON → HTML 静态文件
    # --clean: 覆盖旧报告
    # -o: 指定输出目录
    # Windows 上 allure 是 .bat 文件，需要 shell=True
    subprocess.run(["allure", "generate", str(ALLURE_RESULTS),
                    "--clean", "-o", str(ALLURE_REPORT)],
                   cwd=PROJECT_ROOT, shell=True)
    # Popen: 不阻塞，启动后继续往下走
    # allure open 会一直在后台运行（web 服务器），关掉终端才会停
    subprocess.Popen(["allure", "open", str(ALLURE_REPORT)],
                     cwd=PROJECT_ROOT, shell=True)

if __name__ == "__main__":
    """
    if __name__ == "__main__":  →  只有直接执行 python run.py 时才运行，
                                    如果别的文件 import run.py 则不会自动执行。
    """
    exit_code = run_tests()
    if exit_code != 0:
        print("[WARN] 有用例失败，报告照常生成")
    serve_report()
    print("[DONE] 完成，浏览器已打开")

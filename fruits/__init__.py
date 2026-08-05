# fruits/__init__.py
from .apple import info as apple_info, func1
from .banana import info as banana_info

# ex1) import fruits
# ex2) from fruits import apple_info, banana_info
# ex3) from fruits import *
__all__ = ["apple_info", "banana_info", 'func1']  # ex3 경우일 때 __all__안에 있는 것들만 import 됨.
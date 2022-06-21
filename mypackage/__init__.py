from os import environ

from . import hello_world


def set_version():
    """
    Read the PYTHON_PACKAGE_VERSION from the environment variables. If that variable is not
    defined, return a default value of '1.0.0+pkgdefault'.
    """
    version = environ.get("PYTHON_PACKAGE_VERSION")
    return version if version is not None else "1.0.0+pkgdefault"


__all__ = ["hello_world"]
__version__ = set_version()

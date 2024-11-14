#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" create venv """

import os
from pathlib            import Path
import shutil
from subprocess         import CalledProcessError
from typing             import Optional
from typing             import *
from typing             import ParamSpec
from venv               import EnvBuilder

from structlog          import get_logger

from ia_check_venv.main import check_venv

P     :ParamSpec = ParamSpec('P')
logger           = get_logger()

def create_venv(venv_dir:Optional[Path]=None, clobber:bool=False,)->bool:

	if(venv_dir is None):
		venv_dir = Path()

	if(venv_dir.is_dir() and (not clobber)):
		return False

	if(venv_dir.is_dir() and clobber):
		shutil.rmtree(venv_dir,)
	assert(not venv_dir.is_dir())

	builder: EnvBuilder = EnvBuilder(
        	#system_site_packages=False,   # a Boolean value indicating that the system Python site-packages should be available to the environment (defaults to False).
        	clear                =clobber, # a Boolean value which, if true, will delete the contents of any existing target directory, before creating the environment.
        	#symlinks            =False,   # a Boolean value indicating whether to attempt to symlink the Python binary rather than copying.
        	upgrade              =True,    # a Boolean value which, if true, will upgrade an existing environment with the running Python - for use when that Python has been upgraded in-place (defaults to False).
        	with_pip             =True,    # a Boolean value which, if true, ensures pip is installed in the virtual environment. This uses ensurepip with the --default-pip option.
        	#prompt              =None,    # a String to be used after virtual environment is activated (defaults to None which means directory name of the environment would be used).
                                               # If the special string "." is provided, the basename of the current directory is used as the prompt.
        	upgrade_deps         =False,   # Update the base venv modules to the latest on PyPI
	)
	builder.create(venv_dir)
	assert(venv_dir.is_dir())
	return True

def main()->None:
	assert(not check_venv())
	action:bool = create_venv(clobber=False,)
	print('created:', action,)
	assert(not check_venv())

if __name__ == '__main__':
	main()

__author__:str = 'you.com' # NOQA

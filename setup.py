#!/usr/bin/env python3
from setuptools import setup, find_packages

setup(
    name='python-snake-game',
    version='1.0.0',
    description='A simple snake game for Linux',
    author='yony172017',
    author_email='yony172017@gmail.com',
    url='https://github.com/yony172017-ggt/python-game',
    py_modules=['snake_game'],
    entry_points={
        'console_scripts': [
            'python-snake-game=snake_game:main',
        ],
    },
    install_requires=[
        'pygame>=2.0.0',
    ],
    python_requires='>=3.6',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: X11 Applications',
        'Intended Audience :: End Users/Desktop',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Topic :: Games/Entertainment',
    ],
)

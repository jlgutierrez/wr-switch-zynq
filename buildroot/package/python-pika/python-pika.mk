################################################################################
#
# python-pika
#
################################################################################

PYTHON_PIKA_VERSION = 0.9.14
PYTHON_PIKA_SOURCE  = pika-$(PYTHON_PIKA_VERSION).tar.gz
PYTHON_PIKA_SITE    = https://pypi.python.org/packages/source/p/pika/
PYTHON_PIKA_LICENSE = MIT
PYTHON_PIKA_LICENSE_FILES = LICENSE
PYTHON_PIKA_SETUP_TYPE = setuptools

$(eval $(python-package))

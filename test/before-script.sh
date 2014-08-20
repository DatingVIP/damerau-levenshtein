#!/usr/bin/env bash
#
set -x;
set -e;
set -o pipefail;
#
thisFile="$(readlink -f ${0})";
thisFilePath="$(dirname ${thisFile})";
#

pear channel-discover pear.symfony.com;
pear install --alldeps phpunit/PHPUnit;

composer install --dev --no-interaction --prefer-source;

if [ "${COVERALLS}" = '1' ]; then
	composer require --dev satooshi/php-coveralls:dev-master;
fi

if [ "${PHPCS}" = '1' ]; then
	pear channel-discover pear.cakephp.org;
	pear install --alldeps cakephp/CakePHP_CodeSniffer;
fi

phpenv rehash;

cat << EOF > phpunit.xml;
<?xml version="1.0" encoding="UTF-8"?>
<phpunit>
<filter>
	<whitelist>
		<directory suffix=".php">.</directory>
	</whitelist>
</filter>
</phpunit>
EOF

cat << EOF > .coveralls.yml
# for php-coveralls
src_dir: src
coverage_clover: build/logs/clover.xml
json_path: build/logs/coveralls-upload.json
EOF

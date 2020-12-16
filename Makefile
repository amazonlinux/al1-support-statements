# Build support_info.xml artifacts

.PHONY: all
all: support_info_by_package.html support_info_by_support_statement.html

.PHONY: lint
.PHONY: test
test: lint
lint: support_info.xsd support_info.xml
	xmllint --noout --schema support_info.xsd support_info.xml

support_info_by_package.html: support_info_by_package.xslt support_info.xml
	xsltproc support_info_by_package.xslt support_info.xml > $@


support_info_by_support_statement.html: support_info_by_support_statement.xslt support_info.xml
	xsltproc support_info_by_support_statement.xslt support_info.xml > $@

clean:
	rm -f support_info_by_support_statement.html support_info_by_package.html
